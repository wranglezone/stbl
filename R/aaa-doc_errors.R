#' Document error subclasses
#'
#' These internal helpers build the list of error subclasses in the `@returns`
#' section of a function's documentation. Include `man/rmd/error-classes.md` as
#' a child chunk to introduce the list, then call `.doc_errors()` in a roxygen
#' R chunk (with `results = "asis"` and `echo = FALSE`) with one or more
#' `.doc_err*()` entries. `.doc_errors()` sorts the entries alphabetically by
#' subclass and errors if a subclass is documented more than once.
#'
#' Entries that share wording across many functions have their own helper (for
#' example, `.doc_err_null()`). Helpers for the `coerce` and
#' `incompatible_values` subclasses take the target class so the subclass and
#' text stay consistent. Use `.doc_err()` for one-off entries and
#' `.doc_err_other()` for entries that don't correspond to an stbl subclass.
#'
#' @param ... `.doc_err*()` entries (or lists of entries).
#' @param subclass (`character`) The error subclass, as passed to
#'   `.stbl_abort()` (for example, `"bad_named"` or `c("coerce", "character")`),
#'   without the "stbl-error-" prefix.
#' @param text (`character(1)`) The description, starting with "when" or "for"
#'   and ending with a period. For `.doc_err_other()`, the full bullet text.
#' @param arg (`character(1)`) The name of the argument that controls the check.
#' @param class_name (`character(1)`) The name of the target class as used in
#'   the subclass (for example, `"integer"`).
#' @param description (`character(1)`) The description of the target class as
#'   used in the text (defaults to `class_name`).
#' @param extra (`character(1)`) Optional text appended to the description.
#' @param what (`character(1)`) What can't be converted: `"values"` (the
#'   default) or `"elements"` (for list inputs).
#' @returns `.doc_err*()` return an entry for `.doc_errors()`. `.doc_errors()`
#'   returns markdown.
#' @rdname doc_errors
#' @keywords internal
.doc_errors <- function(...) {
  entries <- unlist(
    lapply(list(...), \(x) if (inherits(x, "stbl_doc_err")) list(x) else x),
    recursive = FALSE
  )
  is_entry <- vapply(entries, inherits, logical(1), what = "stbl_doc_err")
  if (!all(is_entry)) {
    cli::cli_abort("All arguments must be {.fn .doc_err} entries.")
  }
  subclasses <- vapply(entries, \(e) e$subclass, character(1))
  duplicated_subclasses <- unique(subclasses[
    !is.na(subclasses) & duplicated(subclasses)
  ])
  if (length(duplicated_subclasses)) {
    cli::cli_abort(
      "Duplicate error subclass{?es} in documentation: {.val {duplicated_subclasses}}."
    )
  }
  has_subclass <- !is.na(subclasses)
  # Entries without a subclass go last, in the order supplied.
  ordered <- c(
    entries[has_subclass][order(subclasses[has_subclass], method = "radix")],
    entries[!has_subclass]
  )
  bullets <- vapply(ordered, \(e) e$text, character(1))
  # The knit_asis class makes knitr print the markdown as-is.
  structure(paste0("- ", bullets, collapse = "\n"), class = "knit_asis")
}

#' @rdname doc_errors
.doc_err <- function(subclass, text) {
  structure(
    list(
      subclass = paste(subclass, collapse = "-"),
      text = paste0(
        "`<stbl-error-",
        paste(subclass, collapse = "-"),
        ">` ",
        text
      )
    ),
    class = "stbl_doc_err"
  )
}

#' @rdname doc_errors
.doc_err_other <- function(text) {
  structure(list(subclass = NA_character_, text = text), class = "stbl_doc_err")
}

#' @rdname doc_errors
.doc_err_null <- function(arg = "allow_null") {
  .doc_err("bad_null", paste0("for `NULL` values when `", arg, " = FALSE`."))
}

#' @rdname doc_errors
.doc_err_na <- function() {
  .doc_err("bad_na", "for `NA` values when `allow_na = FALSE`.")
}

#' @rdname doc_errors
.doc_err_named <- function() {
  .doc_err("bad_named", "when the presence of names doesn't match `named`.")
}

#' @rdname doc_errors
.doc_err_allowed_names <- function() {
  .doc_err("allowed_names", "when names are not in `named`.")
}

#' @rdname doc_errors
.doc_err_named_fn <- function() {
  .doc_err_other(
    "Errors from `named` when it is a function and a name does not satisfy it."
  )
}

#' @rdname doc_errors
.doc_err_empty <- function(fn = NULL) {
  .doc_err(
    "bad_empty",
    paste0(
      "for empty vectors when `allow_zero_length = FALSE`",
      .in_fn(fn),
      "."
    )
  )
}

#' @rdname doc_errors
.doc_err_scalar <- function(fn = NULL) {
  .doc_err("non_scalar", paste0("for non-scalar vectors", .in_fn(fn), "."))
}

#' @rdname doc_errors
.doc_err_size <- function(
  what = "vector",
  min = "min_size",
  max = "max_size",
  fn = NULL,
  x_vs_y = TRUE
) {
  longer <- paste0("when the ", what, " is longer than `", max, "`")
  shorter <- paste0("when the ", what, " is shorter than `", min, "`")
  entries <- list(
    .doc_err("size_too_large", paste0(longer, .in_fn(fn), ".")),
    .doc_err("size_too_small", paste0(shorter, .in_fn(fn), "."))
  )
  if (x_vs_y) {
    entries <- c(entries, list(.doc_err_size_x_vs_y(min, max, fn = fn)))
  }
  entries
}

#' @rdname doc_errors
.doc_err_size_x_vs_y <- function(
  min = "min_size",
  max = "max_size",
  also = NULL,
  fn = NULL
) {
  text <- paste0("when `", min, "` is larger than `", max, "`")
  if (!is.null(also)) {
    text <- paste0(
      text,
      ", or `",
      also[[1]],
      "` is larger than `",
      also[[2]],
      "`"
    )
  }
  .doc_err("size_x_vs_y", paste0(text, .in_fn(fn), "."))
}

#' @rdname doc_errors
.doc_err_n_characters <- function(scalar = FALSE) {
  what <- if (scalar) "the element has" else "elements have"
  entries <- list(
    .doc_err(
      c("n_characters", "too_few"),
      paste0("when ", what, " fewer characters than `min_characters`.")
    ),
    .doc_err(
      c("n_characters", "too_many"),
      paste0("when ", what, " more characters than `max_characters`.")
    )
  )
  if (!scalar) {
    entries <- c(
      list(.doc_err(
        "n_characters",
        "when some elements have fewer characters than `min_characters` and others have more than `max_characters`."
      )),
      entries
    )
  }
  entries
}

#' @rdname doc_errors
.doc_err_regex <- function() {
  .doc_err("regex_mismatch", "when `regex` checks fail.")
}

#' @rdname doc_errors
.doc_err_tz <- function(when = NULL) {
  prefix <- if (is.null(when)) "" else paste0(when, " and ")
  .doc_err(
    "bad_tz",
    paste0(
      "when ",
      prefix,
      '`tz` is not `""` or a value from [OlsonNames()], ',
      "or is `\"\"` and your local time zone can't be determined."
    )
  )
}

#' @param fn (`character(1)`) Optional name of the function (without
#'   parentheses) to mention, for entries that only apply to one function.
#' @param when (`character(1)`) Optional condition that must hold before `tz`
#'   is checked.
#' @param min,max (`character(1)`) Names of the arguments that bound the size.
#' @param also (`character(2)`) Optional second pair of min and max argument
#'   names for `size_x_vs_y`.
#' @param x_vs_y (`logical(1)`) Whether to include the `size_x_vs_y` entry.
#' @param scalar (`logical(1)`) Whether the entry describes a single value
#'   rather than a vector.
#' @param exclusive (`logical(1)`) Whether the range also has exclusive bounds.
#' @rdname doc_errors
.doc_err_range <- function(exclusive = FALSE) {
  args <- if (exclusive) {
    "`min_value`, `max_value`, `exclusive_min_value`, or `exclusive_max_value`"
  } else {
    "`min_value` or `max_value`"
  }
  .doc_err("outside_range", paste0("when values fall outside ", args, "."))
}

#' @rdname doc_errors
.doc_err_allowed_values <- function(scalar = FALSE) {
  what <- if (scalar) "the value is" else "values are"
  .doc_err("allowed_values", paste0("when ", what, " not in `allowed_values`."))
}

#' @rdname doc_errors
.doc_err_unique <- function() {
  .doc_err(
    "duplicate_elements",
    "when `unique = TRUE` and duplicates are present."
  )
}

#' @rdname doc_errors
.doc_err_function <- function() {
  .doc_err(
    "bad_function",
    "for functions when `coerce_function = FALSE` (the default)."
  )
}

#' @rdname doc_errors
.doc_err_fct_levels <- function() {
  .doc_err("fct_levels", "when values are not present in `levels`.")
}

#' @rdname doc_errors
.doc_err_multiple_of <- function() {
  .doc_err("bad_multiple_of", "when `multiple_of` is not positive.")
}

#' @rdname doc_errors
.doc_err_not_multiple <- function(scalar = FALSE) {
  what <- if (scalar) "the value is" else "values are"
  .doc_err(
    "not_multiple",
    paste0("when ", what, " not a multiple of `multiple_of`.")
  )
}

#' @rdname doc_errors
.doc_err_coerce <- function(
  class_name,
  description = class_name,
  extra = NULL
) {
  .doc_err(
    c("coerce", class_name),
    paste0("when `x` cannot be converted to ", description, extra, ".")
  )
}

#' @rdname doc_errors
.doc_err_incompatible <- function(
  class_name,
  description = class_name,
  what = c("values", "elements")
) {
  what <- rlang::arg_match(what)
  text <- if (what == "values") {
    paste0("when some values cannot be safely converted to ", description, ".")
  } else {
    paste0(
      "when some elements of a list cannot be converted to ",
      description,
      "."
    )
  }
  .doc_err(c("incompatible_values", class_name), text)
}

.in_fn <- function(fn) {
  if (is.null(fn)) "" else paste0(" in [", fn, "()]")
}
