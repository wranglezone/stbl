#' Ensure a double argument meets expectations
#'
#' @description `to_dbl()` checks whether an argument can be coerced to double
#'   without losing information, returning it silently if so. Otherwise an
#'   informative error message is signaled.
#'
#'   `stabilize_dbl()` can check more details about the argument, but is slower
#'   than `to_dbl()`.
#'
#'   `stabilize_dbl_scalar()` and `to_dbl_scalar()` are optimized to check for
#'   length-1 double vectors.
#'
#' @inheritParams .shared-params
#'
#' @returns The argument as a double vector.
#' @family double functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_dbl(1:10)
#' to_dbl("1.1")
#' to_dbl(1 + 0i)
#' to_dbl(NULL)
#' try(to_dbl("a"))
#' try(to_dbl("1.1", coerce_character = FALSE))
#'
#' to_dbl_scalar("1.1")
#' try(to_dbl_scalar(1:10))
#'
#' stabilize_dbl(1:10)
#' stabilize_dbl("1.1")
#' stabilize_dbl(1 + 0i)
#' stabilize_dbl(NULL)
#' try(stabilize_dbl(NULL, allow_null = FALSE))
#' try(stabilize_dbl(c(1.1, NA), allow_na = FALSE))
#' try(stabilize_dbl(letters))
#' try(stabilize_dbl("1.1", coerce_character = FALSE))
#' try(stabilize_dbl(factor(c("1.1", "a"))))
#' try(stabilize_dbl(factor("1.1"), coerce_factor = FALSE))
#' try(stabilize_dbl(1:10, min_value = 3.5))
#' try(stabilize_dbl(1:10, max_value = 7.5))
#'
#' stabilize_dbl_scalar(1.0)
#' stabilize_dbl_scalar("1.1")
#' try(stabilize_dbl_scalar(1:10))
#' stabilize_dbl_scalar(NULL)
#' try(stabilize_dbl_scalar(NULL, allow_null = FALSE))
stabilize_dbl <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls(
    x,
    to_cls_fn = to_dbl,
    to_cls_args = list(
      coerce_character = coerce_character,
      coerce_factor = coerce_factor
    ),
    check_cls_value_fn = .check_value_dbl,
    check_cls_value_fn_args = list(
      min_value = min_value,
      max_value = max_value
    ),
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
#' @rdname stabilize_dbl
stabilize_dbl_scalar <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls_scalar(
    x,
    to_cls_scalar_fn = to_dbl_scalar,
    to_cls_scalar_args = list(
      coerce_character = coerce_character,
      coerce_factor = coerce_factor
    ),
    check_cls_value_fn = .check_value_dbl,
    check_cls_value_fn_args = list(
      min_value = min_value,
      max_value = max_value
    ),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    allow_na = allow_na,
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  )
}

#' Check double values against min and max values
#'
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if `x` passes all checks.
#' @keywords internal
.check_value_dbl <- function(
  x,
  min_value,
  max_value,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  min_value <- to_dbl_scalar(min_value, call = call)
  max_value <- to_dbl_scalar(max_value, call = call)

  min_failure_locations <- .find_failures(x, min_value, `<`)
  max_failure_locations <- .find_failures(x, max_value, `>`)

  if (is.null(min_failure_locations) && is.null(max_failure_locations)) {
    return(invisible(NULL))
  }

  min_msg <- min_failure_locations %&&%
    c(
      "!" = "Values of {.arg {x_arg}} must be >= {min_value}.",
      x = "Values are too low at locations {min_failure_locations}."
    )
  max_msg <- max_failure_locations %&&%
    c(
      "!" = "Values of {.arg {x_arg}} must be <= {max_value}.",
      x = "Values are too high at locations {max_failure_locations}."
    )

  .stbl_abort(
    c(min_msg, max_msg),
    subclass = "outside_range",
    call = call,
    message_env = rlang::current_env()
  )
}
