#' Ensure an argument meets expectations
#'
#' @description
#' `stabilize_arg()` is used by other functions such as [stabilize_int()]. Use
#' `stabilize_arg()` if the type-specific functions will not work for your use
#' case, but you would still like to check things like size or whether the
#' argument is NULL.
#'
#' `stabilize_arg_scalar()` is optimized to check for length-1 vectors.
#'
#' @inheritParams .shared-params
#'
#' @returns `x`, unless one of the checks fails.
#' @family stabilization functions
#' @export
#'
#' @examples
#' wrapper <- function(this_arg, ...) {
#'   stabilize_arg(this_arg, ...)
#' }
#' wrapper(1)
#' wrapper(NULL)
#' wrapper(NA)
#' try(wrapper(NULL, allow_null = FALSE))
#' try(wrapper(NA, allow_na = FALSE))
#' try(wrapper(1, min_size = 2))
#' try(wrapper(1:10, max_size = 5))
#' stabilize_arg_scalar("a")
#' stabilize_arg_scalar(1L)
#' try(stabilize_arg_scalar(1:10))
stabilize_arg <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  check_dots_empty0(..., call = call)

  if (is.null(x)) {
    return(
      .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
    )
  }

  .check_na(x, allow_na = allow_na, x_arg = x_arg, call = call)
  .check_size(
    x,
    min_size = min_size,
    max_size = max_size,
    x_arg = x_arg,
    call = call
  )
  return(x)
}

#' @rdname stabilize_arg
#' @export
stabilize_arg_scalar <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  check_dots_empty0(..., call = call)
  .check_scalar(
    x,
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
  .check_na(x, allow_na = allow_na, x_arg = x_arg, call = call)
  return(x)
}
