#' Coerce to integer with additional checks
#'
#' Compared to [to_int()], `stabilize_int()` checks more details, but is slower.
#' `stabilise_int()`, `stabilize_integer()`, and `stabilise_integer()` are
#' synonyms of `stabilize_int()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as an integer vector, or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-integer>` when `x` cannot be coerced to integer.
#'   - `<stbl-error-incompatible_values-integer>` when some values cannot be
#'   safely converted to integer.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-size_too_small>` when the vector is shorter than `min_size`.
#'   - `<stbl-error-size_too_large>` when the vector is longer than `max_size`.
#'   - `<stbl-error-outside_range>` when values fall outside `min_value` or
#'   `max_value`.
#' @family integer functions
#' @family stabilization functions
#' @export
#'
#' @examples
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

#' Coerce to length-1 integer with additional checks
#'
#' Checks whether a vector can be coerced to a length-1 integer vector.
#' `stabilize_int_scalar()` is optimized to check for length-1 integer vectors
#' (compared to [stabilize_int()] with `max_size = 1`). `stabilise_int_scalar`,
#' `stabilize_integer_scalar()`, and `stabilise_integer_scalar` are synonyms of
#' `stabilize_int_scalar()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a length-1 integer vector, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-integer>` when `x` cannot be coerced to integer.
#'   - `<stbl-error-incompatible_values-integer>` when some values cannot be
#'   safely converted to integer.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-outside_range>` when values fall outside `min_value` or
#'   `max_value`.
#' @family integer functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_int_scalar(1L)
#' stabilize_int_scalar("1")
#' try(stabilize_int_scalar(1:10))
#' try(stabilize_int_scalar(NULL))
#' stabilize_int_scalar(NULL, allow_null = TRUE)
stabilize_int_scalar <- function(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
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
#' @rdname stabilize_int_scalar
stabilize_integer_scalar <- stabilize_int_scalar

#' @export
#' @rdname stabilize_int_scalar
stabilise_int_scalar <- stabilize_int_scalar

#' @export
#' @rdname stabilize_int_scalar
stabilise_integer_scalar <- stabilize_int_scalar
