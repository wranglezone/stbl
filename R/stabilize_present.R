#' Deprecated: use `assert_present()` instead
#'
#' `stabilize_present()` was renamed to [assert_present()] because it doesn't
#' stabilize (coerce) `x` in any way; it only asserts that `x` is not `NULL`.
#' Calling `stabilize_present()` now throws an error directing you to
#' [assert_present()] instead.
#'
#' @inheritParams .shared-params
#' @returns This function does not return a value; it always throws an error
#'   condition with classes `<stbl-error-deprecated>`, `<stbl-error>`,
#'   `<stbl-condition>`, `<rlang_error>`, `<error>`, and `<condition>`.
#' @keywords internal
#' @export
stabilize_present <- function(x, x_arg = caller_arg(x), call = caller_env()) {
  .stbl_abort(
    message = c(
      "{.fn stabilize_present} was renamed to {.fn assert_present}.",
      i = "Please call {.fn assert_present} instead."
    ),
    subclass = "deprecated",
    call = call
  )
}
