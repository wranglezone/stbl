#' Replace a stbl error with a custom message
#'
#' Catches a `stbl` error with the specified `subclass` and replaces its
#' message with a new one. Use this to provide more context-specific error
#' messages when calling `stbl` functions inside your own functions. See
#' the documentation of each `stabilize_*()` or `to_*()` function for the types
#' of errors it throws.
#'
#' @param message (`character`) The replacement error message. Formatted with
#'   [cli::cli_bullets()].
#' @inheritParams ignore_stbl_error
#' @inheritParams .shared-params
#'
#' @returns The result of `expr`, or an error with the replacement message if
#'   a matching `{stbl}` error is thrown.
#' @export
#'
#' @examples
#' my_fn <- function(x) {
#'   x <- to_chr(x) |>
#'     replace_stbl_error(
#'       subclass = c("coerce", "character"),
#'       message = "{.arg x} must be a character vector of widgets"
#'     )
#' }
#' try(my_fn(data.frame()))
#'
#' # Specify a class to check for expected errors with testthat::expect_error()
#' my_fn2 <- function(x) {
#'   x <- to_chr(x) |>
#'     replace_stbl_error(
#'       subclass = c("coerce", "character"),
#'       message = "{.arg x} must be a character vector of widgets",
#'       additional_class = "mypkg-error-bad_widget"
#'     )
#' }
#' try(my_fn2(data.frame()))
replace_stbl_error <- function(
  expr,
  subclass,
  message,
  additional_class = character(),
  message_env = caller_env()
) {
  class_to_catch <- .compile_dash("stbl", "error", .collapse_dash(subclass))
  rlang::try_fetch(
    expr,
    !!class_to_catch := function(cnd) {
      # Don't re-attach cli/rlang classes
      stbl_classes <- class(cnd)[startsWith(class(cnd), "stbl-")]
      new_class <- c(additional_class, stbl_classes)
      cli::cli_abort(
        message = message,
        class = new_class,
        call = cnd$call,
        .envir = message_env
      )
    }
  )
}
