#' Ensure an integer argument meets expectations
#'
#' @description `to_int()` checks whether an argument can be coerced to integer
#'   without losing information, returning it silently if so. Otherwise an
#'   informative error message is signaled. `to_integer` is a synonym of
#'   `to_int()`.
#'
#'   `stabilize_int()` can check more details about the argument, but is slower
#'   than `to_int()`. `stabilise_int()`, `stabilize_integer()`, and
#'   `stabilise_integer()` are synonyms of `stabilize_int()`.
#'
#'   `stabilize_int_scalar()` and `to_int_scalar()` are optimized to check for
#'   length-1 integer vectors. `stabilise_int_scalar`,
#'   `stabilize_integer_scalar()`, and `stabilise_integer_scalar` are synonyms of
#'   `stabilize_int_scalar()`, and `to_integer_scalar()` is a synonym of
#'   `to_int_scalar()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The argument as an integer vector.
#' @family integer functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_int(1:10)
#' to_int("1")
#' to_int(1 + 0i)
#' to_int(NULL)
#' try(to_int(c(1, 2, 3.1, 4, 5.2)))
#' try(to_int("1", coerce_character = FALSE))
#' try(to_int(c("1", "2", "3.1", "4", "5.2")))
#'
#' to_int_scalar("1")
#' try(to_int_scalar(1:10))
#'
#' stabilize_int(1:10)
#' stabilize_int("1")
#' stabilize_int(1 + 0i)
#' stabilize_int(NULL)
#' try(stabilize_int(NULL, allow_null = FALSE))
#' try(stabilize_int(c(1, NA), allow_na = FALSE))
#' try(stabilize_int(letters))
#' try(stabilize_int("1", coerce_character = FALSE))
#' try(stabilize_int(factor(c("1", "a"))))
#' try(stabilize_int(factor("1"), coerce_factor = FALSE))
#' try(stabilize_int(1:10, min_value = 3))
#' try(stabilize_int(1:10, max_value = 7))
#'
#' stabilize_int_scalar(1L)
#' stabilize_int_scalar("1")
#' try(stabilize_int_scalar(1:10))
#' stabilize_int_scalar(NULL)
#' try(stabilize_int_scalar(NULL, allow_null = FALSE))
stabilize_int <- function(
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
    to_cls_fn = to_int,
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
#' @rdname stabilize_int
stabilize_integer <- stabilize_int

#' @export
#' @rdname stabilize_int
stabilise_int <- stabilize_int

#' @export
#' @rdname stabilize_int
stabilise_integer <- stabilize_int

#' @export
#' @rdname stabilize_int
stabilize_int_scalar <- function(
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
    to_cls_scalar_fn = to_int_scalar,
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

#' @export
#' @rdname stabilize_int
stabilize_integer_scalar <- stabilize_int_scalar

#' @export
#' @rdname stabilize_int
stabilise_int_scalar <- stabilize_int_scalar

#' @export
#' @rdname stabilize_int
stabilise_integer_scalar <- stabilize_int_scalar
