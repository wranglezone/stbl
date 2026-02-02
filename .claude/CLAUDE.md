# stbl

## Package overview

**stbl** provides a consistent, opinionated set of functions to validate, coerce, and stabilize function arguments. The philosophy follows Postel's Law: be liberal in what you accept (coerce when safe), conservative in what you return (ensure inputs have expected classes and features).

**Key goals:**
- Fail fast with clear error messages before expensive operations
- Intelligently coerce compatible types (e.g., `"1"` to `1L`)
- Provide detailed validation of argument structure and content

## Function families

| Family | Purpose | Speed | Example |
|--------|---------|-------|---------|
| `to_*()` | Fast type coercion | Fast | `to_int("1")` → `1L` |
| `is_*_ish()` | Check if coercible (single logical) | Fast | `is_int_ish(1.0)` → `TRUE` |
| `are_*_ish()` | Check if coercible (element-wise) | Fast | `are_int_ish(c(1, 1.5))` → `c(TRUE, FALSE)` |
| `stabilize_*()` | Comprehensive validation | Slower | `stabilize_int(x, min_value = 0)` |
| `specify_*()` | Create pre-configured validators | N/A | `specify_int(min_value = 0)` |

**Supported types:** `chr`/`character`, `dbl`/`double`, `int`/`integer`, `lgl`/`logical`, `fct`/`factor`, `lst`/`list`

**Variants:**
- `*_scalar()` — optimized for length-1 values
- British spellings — `stabilise_*()` as synonyms

## Architecture

### S3 dispatch

The `to_*()` and related functions use S3 dispatch based on input type. Methods live in `R/to_*.R` files with naming pattern `to_{type}.{input_class}`.

### Error handling

Use `.stbl_abort()` (defined in `R/aaa-conditions.R`) for all errors within this package. This creates classed errors with hierarchy `stbl-error-{subclass}` that can be caught selectively with `tryCatch()`.

```r
.stbl_abort(
  message = "{.arg {arg_name}} must be positive.",
  subclass = "bad_value",
  call = caller_env(), # Often passes a call arg
  message_env = current_env(), # Or wherever variables are defined for message
  parent = NULL # Rarely anything else, but might pass a parent through
)
```

Note: `pkg_abort()` is the exported generic version for use by other packages; `.stbl_abort()` is our internal wrapper.

### Internal vs exported functions

- Internal function names are prefixed with `.` (e.g., `.check_size()`)
- All user-facing functions should be exported with roxygen2 `@export`

## Adding new functionality

### New type (e.g., `to_date()`)

1. Create `R/to_date.R` with the generic and S3 methods
2. Create `R/are_date.R` and `R/is_date.R` for predicates
3. Create `R/stabilize_date.R` for comprehensive validation
4. Add shared parameters to `R/aaa-shared_params.R` if needed
5. Add tests in `tests/testthat/test-to_date.R`, etc.
6. Update `_pkgdown.yml` with new topics
7. Add entry to `NEWS.md`

### New S3 method for existing type

Add the method to the appropriate `R/to_*.R` file, following existing patterns for error handling and list flattening.

## Project skills

Load these project skills as needed from `.claude/skills/{skill-name}/SKILL.md`:

- **`implement-feature`** — When implementing new features, refactoring code, or writing tests. Includes coding philosophy, testing patterns, and development wrap-up steps.
- **`create-github-issue`** — When creating GitHub issues. Uses user-story format and posts via `gh::gh()` with issue type support.

## R package development

### Key commands

```
# To run code
Rscript -e "devtools::load_all(); code"

# To run all tests
Rscript -e "devtools::test()"

# To run all tests for files starting with {name}
Rscript -e "devtools::test(filter = '^{name}')"

# To run all tests for R/{name}.R
Rscript -e "devtools::test_active_file('R/{name}.R')"

# To run a single test "blah" for R/{name}.R
Rscript -e "devtools::test_active_file('R/{name}.R', desc = 'blah')"

# To redocument the package
Rscript -e "devtools::document()"

# To check pkgdown documentation
Rscript -e "pkgdown::check_pkgdown()"

# To check the package with R CMD check
Rscript -e "devtools::check()"

# To format code
air format .
```

### Coding

* Always run `air format .` after generating code
* Use the base pipe operator (`|>`) not the magrittr pipe (`%>%`)
* Don't use `_$x` or `_$[["x"]]` since this package must work on R 4.1.
* Use `\() ...` for single-line anonymous functions. For all other cases, use `function() {...}` 
* Internal function names should be prefixed with `.`.

### Namespacing

Use `pkg::fn()` for all external package functions, with these exceptions:
- Functions from the `base` package
- Functions from `stbl` itself (including explicitly imported functions)
- Functions from `testthat` (and related packages like `httptest2`, `shinytest2`) when writing tests
- Functions from `shiny` when working within a Shiny app

### Testing

- Tests for `R/{name}.R` go in `tests/testthat/test-{name}.R`. 
- All new code should have an accompanying test.
- If there are existing tests, place new tests next to similar existing tests.
- Strive to keep your tests minimal with few comments.

### Documentation

- Every user-facing function should be exported and have roxygen2 documentation.
- Wrap roxygen comments at 80 characters.
- Reused parameters should be documented in `R/aaa-shared_params.R`, almost always in the `.shared-params` topic.
- If a function uses reused parameters, use `@importParams .shared-params` (or whatever topic holds the shared params) *after* function-specific `@param` definitions.
- Internal functions should have roxygen documentation, with `@keywords internal` instead of `@export`.
- Whenever you add a new (non-internal) documentation topic, also add the topic to `_pkgdown.yml`. 
- Always re-document the package after changing a roxygen2 comment.
- Use `pkgdown::check_pkgdown()` to check that all topics are included in the reference index.

### `NEWS.md`

- Every user-facing change should be given a bullet in `NEWS.md`. Do not add bullets for small documentation changes or internal refactorings.
- Each bullet should briefly describe the change to the end user and mention the related issue in parentheses.
- A bullet can consist of multiple sentences but should not contain any new lines (i.e. DO NOT line wrap).
- If the change is related to a function, put the name of the function early in the bullet.
- Order bullets alphabetically by function name. Put all bullets that don't mention function names at the beginning.

### GitHub

- If you use `gh` to retrieve information about an issue, always use `--comments` to read all the comments.

### Writing

- Use sentence case for headings.
- Use US English.

### Proofreading

If the user asks you to proofread a file, act as an expert proofreader and editor with a deep understanding of clear, engaging, and well-structured writing. 

Work paragraph by paragraph, always starting by making a TODO list that includes individual items for each top-level heading. 

Fix spelling, grammar, and other minor problems without asking the user. Label any unclear, confusing, or ambiguous sentences with a FIXME comment.

Only report what you have changed.
