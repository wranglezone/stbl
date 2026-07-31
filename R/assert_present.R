#' Require a value to be non-NULL
#'
#' `assert_present()` validates that a value is not `NULL`. Any non-`NULL`
#' value passes through unchanged. This is useful as an element specification
#' in [stabilize_lst()] when you need to require a named element without
#' imposing any type constraints on its value.
#'
#' @inheritParams .shared-params
#' @returns The value, unchanged.
#' @family list functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' assert_present("any value")
#' assert_present(list(1, 2, 3))
#' try(assert_present(NULL))
#'
#' # Use as a named element spec in stabilize_lst()
#' stabilize_lst(list(data = mtcars), data = assert_present)
assert_present <- function(
  x,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  if (is.null(x)) {
    .stop_null(x_arg = x_arg, call = call)
  }
  x
}
