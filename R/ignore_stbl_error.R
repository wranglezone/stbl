#' Ignore a stbl error class
#'
#' Silences a `stbl` error with the specified `subclass`. Other errors
#' (including other `stbl` errors) are not caught and propagate normally. See
#' the documentation of each `stabilize_*()` or `to_*()` function for the types
#' of errors it throws.
#'
#' @param expr An expression to evaluate.
#' @param subclass (`character`) The subclass(es) of the `stbl` error to
#'   ignore. Combined with `"stbl-error-"` to form the class name to intercept.
#'   For example, `c("coerce", "character")` silences errors of class
#'   `stbl-error-coerce-character` ([stabilize_chr()]), while `c("coerce")`
#'   silences any `stbl-error-coerce` error.
#'
#' @returns The result of `expr` if no matching error is thrown, or `NULL`
#'   if a matching `stbl` error is caught.
#' @export
#'
#' @examples
#' ignore_stbl_error(to_chr(data.frame()), subclass = c("coerce", "character"))
#' ignore_stbl_error(to_chr("hello"), subclass = c("coerce", "character"))
ignore_stbl_error <- function(expr, subclass) {
  class_to_catch <- .compile_dash("stbl", "error", .collapse_dash(subclass))
  rlang::try_fetch(
    expr,
    !!class_to_catch := function(cnd) NULL
  )
}
