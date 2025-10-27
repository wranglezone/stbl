#' Ensure a logical argument meets expectations
#'
#' @description `to_lgl()` checks whether an argument can be coerced to logical
#'   without losing information, returning it silently if so. Otherwise an
#'   informative error message is signaled.
#'
#'   `stabilize_lgl()` can check more details about the argument, but is slower
#'   than `to_lgl()`.
#'
#'   `stabilize_lgl_scalar()` and `to_lgl_scalar()` are optimized to check for
#'   length-1 logical vectors.
#'
#' @inheritParams .shared-params
#'
#' @returns The argument as a logical vector.
#' @family logical functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_lgl(TRUE)
#' to_lgl("TRUE")
#' to_lgl(1:10)
#' to_lgl(NULL)
#' try(to_lgl(NULL, allow_null = FALSE))
#' try(to_lgl(letters))
#' try(to_lgl(list(TRUE)))
#'
#' to_lgl_scalar("TRUE")
#' try(to_lgl_scalar(c(TRUE, FALSE)))
#'
#' stabilize_lgl(c(TRUE, FALSE, TRUE))
#' stabilize_lgl("true")
#' stabilize_lgl(NULL)
#' try(stabilize_lgl(NULL, allow_null = FALSE))
#' try(stabilize_lgl(c(TRUE, NA), allow_na = FALSE))
#' try(stabilize_lgl(letters))
#' try(stabilize_lgl(c(TRUE, FALSE, TRUE), min_size = 5))
#' try(stabilize_lgl(c(TRUE, FALSE, TRUE), max_size = 2))
#'
#' stabilize_lgl_scalar(TRUE)
#' stabilize_lgl_scalar("TRUE")
#' try(stabilize_lgl_scalar(c(TRUE, FALSE, TRUE)))
#' stabilize_lgl_scalar(NULL)
#' try(stabilize_lgl_scalar(NULL, allow_null = FALSE))
stabilize_lgl <- function(
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
  .stabilize_cls(
    x,
    to_cls_fn = to_lgl,
    allow_null = allow_null,
    allow_na = allow_na,
    min_size = min_size,
    max_size = max_size,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' @export
#' @rdname stabilize_lgl
stabilize_lgl_scalar <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls_scalar(
    x,
    to_cls_scalar_fn = to_lgl_scalar,
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    allow_na = allow_na,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}
