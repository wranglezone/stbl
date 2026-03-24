---
name: r-code
trigger: writing R functions / API design / error handling
description: Guide for writing R code. Use when writing new functions, designing APIs, or reviewing/modifying existing R code.
---

# R code

This skill covers how to design and write R functions — including naming conventions, signatures, API conventions, input validation, error handling, and common pitfalls. For documenting functions, use the `document` skill. For tests, use the `tdd-workflow` skill.

## Naming conventions

### Functions

Functions use `snake_case` and should be **verbs or verb phrases** that describe what the function does:

```r
fetch_records()
build_summary()
validate_input()
```

A function name should be descriptive enough to make its purpose clear without a comment. Prefer clarity over brevity — don't abbreviate unless there is a widely understood convention (e.g. `df` for data frame, `dir` for directory).

Internal helpers use a dot prefix:

```r
.parse_response()
.validate_columns()
```

### Parameters

Parameters use `snake_case` and should generally be **nouns**, occasionally adjectives. The same rule applies: clarity over brevity.

```r
# Good
fetch_records(file_path, page_size, overwrite)

# Bad — unclear abbreviations
fetch_records(fp, ps, ow)
```

## Coding style

- Always run `air format .` after generating code.
- Use the base pipe operator (`|>`) not the magrittr pipe (`%>`).
- Don't use `_$x` or `_$[["x"]]` since this package must work on R 4.1.
- Use `\() ...` for single-line anonymous functions. For all other cases, use `function() {...}`.

## File organization

One exported function per file: `R/{function_name}.R` (e.g. `fetch_records()` → `R/fetch_records.R`). Internal helpers used exclusively by that function live in the same file. Shared helpers go in `R/utils.R` or `R/utils-{topic}.R` (e.g. `R/utils-parsing.R`).

## Function design

**Functional core, imperative shell** — pure, testable functions that accept data and return data form the core. The imperative shell orchestrates program flow, manages state, and calls the functional core (e.g., R6 methods, Shiny server logic).

Functions should be **small and single-purpose**. Each function should operate at a **single level of abstraction**: it either orchestrates calls to other functions, or performs a direct operation on data, but does not mix the two.

```r
# Orchestrator — delegates to focused helpers
build_report <- function(data, output_path) {
  data <- .clean_data(data)
  summary <- .compute_summary(data)
  .write_report(summary, output_path)
}

# Worker — performs one direct operation
.clean_data <- function(data) {
  data |>
    dplyr::filter(!is.na(value)) |>
    dplyr::mutate(value = round(value, 2))
}
```

Name functions well enough that their purpose is obvious from the call site. When reading the orchestrator above, each step is self-documenting — no comments needed.

**Simplify control flow** — prefer guard clauses and returning early over complex if/else structures.

**Pure conditionals** — the expression inside a conditional check should not cause side effects. Extract the pure check from the impure action into separate functions if needed.

## General API design patterns

**Enum-like arguments** — declare choices as the default vector; resolve with `rlang::arg_match()` at the top of the function:

```r
summarize_data <- function(x, method = c("mean", "median")) {
  method <- rlang::arg_match(method)
  # method is now guaranteed to be "mean" or "median"
}
```

**`NULL` as "not provided"** — use `NULL` as the default for optional arguments where there is no sensible scalar fallback; check with `is.null()`:

```r
fetch_records <- function(x, output_column = NULL) {
  if (!is.null(output_column)) { ... }
}
```

**S3 object construction** — build as a named list, set class explicitly:

```r
.new_summary <- function(values, method) {
  out <- list(values = values, method = method)
  class(out) <- c(paste0("summary_", method), "data_summary")
  out
}
```

**`call` propagation in internal validators** — helpers that validate arguments and may throw errors should accept and forward `call`:

```r
.check_non_empty <- function(x, call = rlang::caller_env()) {
  if (length(x) == 0L) {
    .pkg_abort("Input {.arg x} cannot be empty.", "empty_input", call = call)
  }
}

process_data <- function(x, call = rlang::caller_env()) {
  .check_non_empty(x, call = call)
  ...
}
```

**Return tibbles, not data frames:**

```r
summarize_data <- function(x) {
  result |> tibble::as_tibble()
}
```

## Input validation

Use `to_*()` and `stabilize_*()` to validate parameters. These functions coerce when safe and fail with clear error messages when not.

- **`to_*()`** — simple type coercion. Use when you need to ensure a parameter is the right type but don't need additional constraints.
- **`stabilize_*()`** — coercion plus content validation (regex, ranges, etc.). Use when simple type coercion isn't enough.

**Validate in the function that uses the parameter**, not in a caller that passes it through. This preserves R's lazy evaluation — if a parameter is never used on a code path, it is never evaluated or validated.

```r
# Good — validation happens where the parameter is used
build_report <- function(data, title, page_size) {
  data <- .clean_data(data)
  summary <- .compute_summary(data, page_size)
  .write_report(summary, title)
}

.compute_summary <- function(data, page_size, call = rlang::caller_env()) {
  page_size <- to_int_scalar(page_size, call = call)
  ...
}

.write_report <- function(summary, title, call = rlang::caller_env()) {
  title <- to_chr_scalar(title, call = call)
  ...
}
```

```r
# Bad — validates everything eagerly, breaking lazy evaluation
build_report <- function(data, title, page_size) {
  title <- to_chr_scalar(title)
  page_size <- to_int_scalar(page_size)
  ...
}
```

When `call` is available (because the function accepts it), always pass it to `to_*()` / `stabilize_*()` calls so error messages point to the user's call frame.

## Internal vs. exported functions

Export a function when:
- Users will call it directly
- Other packages may want to extend it
- It is a stable, intentional part of the API

Keep a function internal when:
- It is an implementation detail that may change
- It is only used within the package
- Exporting it would clutter the user-facing API

Internal helpers use a dot prefix (e.g. `.parse_response()`).

## Error handling

Use `.stbl_abort()` (defined in `R/aaa-conditions.R`) for all errors within this package. This is the internal wrapper around the exported `pkg_abort()` function. It creates classed errors with hierarchy `stbl-error-{subclass}` that can be caught selectively with `tryCatch()`.

```r
.stbl_abort(
  message = "{.arg {arg_name}} must be positive.",
  subclass = "bad_value",
  call = caller_env(),
  message_env = current_env(),
  parent = NULL
)
```

Always pass `call = call` (or `call = rlang::caller_env()`) so errors point to the user's call frame, not an internal helper.

## S3 dispatch

The `to_*()` and related functions use S3 dispatch based on input type. Methods live in `R/to_*.R` files with naming pattern `to_{type}.{input_class}`.

## Adding new functionality

### New type (e.g., `to_date()`)

1. Create `R/to_date.R` with the generic and S3 methods
2. Create `R/are_date.R` and `R/is_date.R` for predicates
3. Create `R/stabilize_date.R` for comprehensive validation
4. Add shared parameters to `R/aaa-shared_params.R` if needed
5. Add tests in `tests/testthat/test-to_date.R`, etc.
6. Update `_pkgdown.yml` with new topics

### New S3 method for existing type

Add the method to the appropriate `R/to_*.R` file, following existing patterns for error handling and list flattening.

## Common package mistakes

```r
# Never use library() inside package code
library(dplyr)          # Wrong
dplyr::filter(...)      # Right
# or `@importFrom dplyr filter` if used extensively

# Never modify global state without restoring it
options(my_option = TRUE)                    # Wrong
withr::local_options(list(my_option = TRUE)) # Right

# Use system.file() for package data, not hardcoded paths
read.csv("/home/user/data.csv")                         # Wrong
system.file("extdata", "data.csv", package = "mypkg")   # Right
```

## Dependencies

### Use existing imports first

Packages already in `Imports` in `DESCRIPTION` should be preferred over base R equivalents: `purrr::map()` over `lapply()`, `rlang::is_*()` predicates over `is.*()`, and `withr::local_*()` over manual `on.exit()` state management.

### When to add a new dependency

Add a dependency when it provides significant functionality that would be complex or brittle to reimplement — date parsing, web requests, complex string manipulation. Stick with base R or existing imports when the solution is straightforward.

**Adding a new dependency requires explicit discussion with the developer.**
