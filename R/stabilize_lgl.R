#' Coerce to logical with additional checks
#'
#' Compared to [to_lgl()], `stabilize_lgl()` checks more details, but is
#' slower. `stabilise_lgl()`, `stabilize_logical()`, and `stabilise_logical()`
#' are synonyms of `stabilize_lgl()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a logical vector, or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-logical>` when `x` cannot be coerced to logical.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-size_too_small>` when the vector is shorter than `min_size`.
#'   - `<stbl-error-size_too_large>` when the vector is longer than `max_size`.
#'   - `<stbl-error-allowed_values>` when values are not in `allowed_values`.
#' @family logical functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_lgl(c(TRUE, FALSE, TRUE))
#' stabilize_lgl("true")
#' stabilize_lgl(NULL)
#' try(stabilize_lgl(NULL, allow_null = FALSE))
#' try(stabilize_lgl(c(TRUE, NA), allow_na = FALSE))
#' try(stabilize_lgl(letters))
#' try(stabilize_lgl(c(TRUE, FALSE, TRUE), min_size = 5))
#' try(stabilize_lgl(c(TRUE, FALSE, TRUE), max_size = 2))
#' try(stabilize_lgl(c(TRUE, FALSE), allowed_values = TRUE))
stabilize_lgl <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls(
    x,
    to_cls_fn = to_lgl,
    check_cls_value_fn = .check_value_lgl,
    check_cls_value_fn_args = list(
      allowed_values = allowed_values
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
#' @rdname stabilize_lgl
stabilize_logical <- stabilize_lgl

#' @export
#' @rdname stabilize_lgl
stabilise_lgl <- stabilize_lgl

#' @export
#' @rdname stabilize_lgl
stabilise_logical <- stabilize_lgl

#' Coerce to length-1 logical with additional checks
#'
#' Checks whether a vector can be coerced to a length-1 logical vector.
#' `stabilize_lgl_scalar()` is optimized to check for length-1 logical vectors
#' (compared to [stabilize_lgl()] with `max_size = 1`). `stabilise_lgl_scalar`,
#' `stabilize_logical_scalar()`, and `stabilise_logical_scalar` are synonyms of
#' `stabilize_lgl_scalar()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a length-1 logical vector, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-logical>` when `x` cannot be coerced to logical.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-allowed_values>` when the value is not in
#'   `allowed_values`.
#' @family logical functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_lgl_scalar(TRUE)
#' stabilize_lgl_scalar("TRUE")
#' try(stabilize_lgl_scalar(c(TRUE, FALSE, TRUE)))
#' try(stabilize_lgl_scalar(NULL))
#' stabilize_lgl_scalar(NULL, allow_null = TRUE)
stabilize_lgl_scalar <- function(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls_scalar(
    x,
    to_cls_scalar_fn = to_lgl_scalar,
    check_cls_value_fn = .check_value_lgl,
    check_cls_value_fn_args = list(
      allowed_values = allowed_values
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
#' @rdname stabilize_lgl_scalar
stabilize_logical_scalar <- stabilize_lgl_scalar

#' @export
#' @rdname stabilize_lgl_scalar
stabilise_lgl_scalar <- stabilize_lgl_scalar

#' @export
#' @rdname stabilize_lgl_scalar
stabilise_logical_scalar <- stabilize_lgl_scalar

#' Check logical values against allowed values
#'
#' @inheritParams .shared-params
#' @returns `NULL`, invisibly, if `x` passes all checks.
#' @keywords internal
.check_value_lgl <- function(
  x,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  allowed_values <- to_lgl(allowed_values, allow_null = TRUE, call = call)
  .check_allowed_values(
    x,
    allowed_values = allowed_values,
    x_arg = x_arg,
    call = call
  )
  invisible(NULL)
}
