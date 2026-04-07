#' A wrapper for `glue::glue` with bracket delimiters
#'
#' @param ... Arguments passed on to [glue::glue()]. Usually expects unnamed
#'   arguments but named arguments other than `.envir`, `.open`, and `.close`
#'   are acceptable.
#' @param env The environment in which to evaluate the expressions.
#' @returns A character string with evaluated expressions.
#' @keywords internal
.glue2 <- function(..., env = caller_env()) {
  glue(..., .envir = env, .open = "[", .close = "]")
}

#' Escape curly braces for safe printing with cli
#'
#' @param msg `(character)` The messages to escape.
#' @returns The messages with curly braces escaped.
#' @keywords internal
.cli_escape <- function(msg) {
  msg <- gsub("{", "{{", msg, fixed = TRUE)
  gsub("}", "}}", msg, fixed = TRUE)
}

#' Wrap text in cli markup
#'
#' @param x `(character)` The string to wrap.
#' @param tag `(character)` The cli class to apply (e.g., "val", "var").
#' @returns A character vector the same length as `x` with cli markup.
#' @keywords internal
.cli_mark <- function(x, tag) {
  paste0("{.", tag, " ", x, "}")
}

#' NULL-coalescing-like operator
#'
#' If the left-hand side is not `NULL`, returns the right-hand side. Otherwise,
#' returns `NULL`. This is useful for guarding expressions that should only be
#' executed if a value is not `NULL`. Meant to be similar to the `%||%` operator
#' (which returns `y` if `x` is `NULL`).
#'
#' @param x The object to check for `NULL`.
#' @param y The value to return if `x` is not `NULL`.
#'
#' @returns `NULL` or the value of `y`.
#' @keywords internal
`%&&%` <- function(x, y) {
  if (is.null(x)) {
    NULL
  } else {
    y
  }
}

#' Safely find failure locations in a vector
#'
#' @param x The vector to check.
#' @param check_value The value to check against (e.g., a regex pattern). If
#'   `NULL`, the check is skipped.
#' @param check_fn The function to use for checking.
#' @returns An integer vector of failure locations, or `NULL` if there are no
#'   failures or the check is skipped.
#' @keywords internal
.find_failures <- function(x, check_value, check_fn) {
  failures <- check_value %&&% check_fn(x, check_value)

  if (any(failures)) {
    return(which(failures))
  }

  return(NULL)
}
