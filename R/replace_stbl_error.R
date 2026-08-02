#' Replace a stbl error with a custom message
#'
#' Catches a `{stbl}` error with the specified `subclass` and replaces its
#' message with a new one. Use this to provide more context-specific error
#' messages when calling `{stbl}` functions inside your own package.
#'
#' The `subclass` argument mirrors the subclass hierarchy used when the error
#' was originally thrown. For example, an error with class
#' `stbl-error-coerce-character` is caught with
#' `subclass = c("coerce", "character")`. Any `coerce` error (regardless of
#' the target type) is caught with `subclass = c("coerce")`. Similarly,
#' `stbl-error-incompatible_values-integer` is caught with
#' `subclass = c("incompatible_values", "integer")`.
#'
#' @param expr An expression to evaluate.
#' @param subclass (`character`) The subclass(es) of the `{stbl}` error to
#'   catch. Combined with `"stbl-error-"` to form the class name to intercept.
#'   For example, `c("coerce", "character")` catches errors of class
#'   `stbl-error-coerce-character`, while `c("coerce")` catches any
#'   `stbl-error-coerce` error.
#' @param message (`character`) The replacement message. Formatted with
#'   [cli::cli_bullets()].
#' @param additional_class (`character`) Additional classes to prepend to the
#'   error class list. These are used exactly as-is — no `"stbl-error-"` prefix
#'   is added. Defaults to `character()` (no additional classes).
#' @inheritParams .shared-params
#'
#' @returns The result of `expr`, or an error with the replacement message if
#'   a matching `{stbl}` error is thrown.
#' @export
#'
#' @examples
#' my_fn <- function(x) {
#'   replace_stbl_error(
#'     to_chr(x),
#'     subclass = c("coerce", "character"),
#'     message = "{.arg x} must be a character string."
#'   )
#' }
#' try(my_fn(data.frame()))
#'
#' my_fn2 <- function(x) {
#'   replace_stbl_error(
#'     to_chr(x),
#'     subclass = c("coerce", "character"),
#'     message = "{.arg x} must be a character string.",
#'     additional_class = "mypkg-error-bad_chr"
#'   )
#' }
#' try(my_fn2(data.frame()))
replace_stbl_error <- function(
  expr,
  subclass,
  message,
  call = caller_env(),
  message_env = call,
  additional_class = character()
) {
  class_to_catch <- .compile_dash("stbl", "error", .collapse_dash(subclass))
  rlang::try_fetch(
    expr,
    !!class_to_catch := function(cnd) {
      stbl_classes <- class(cnd)[startsWith(class(cnd), "stbl-")]
      new_class <- c(additional_class, stbl_classes)
      cli::cli_abort(
        message = message,
        class = new_class,
        call = cnd$call %||% call,
        .envir = message_env
      )
    }
  )
}
