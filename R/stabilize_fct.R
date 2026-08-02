#' Coerce to factor with additional checks
#'
#' Compared to [to_fct()], `stabilize_fct()` checks more details, but is
#' slower. `stabilise_fct()`, `stabilize_factor()`, and `stabilise_factor()`
#' are synonyms of `stabilize_fct()`.
#'
#' @inheritParams .shared-params
#' @param levels `(character)` Expected levels. If `NULL` (default), the levels
#'   will be computed by [base::factor()].
#'
#' @returns The input as a factor, or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-factor>` when `x` cannot be coerced to factor.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-size_too_small>` when the vector is shorter than `min_size`.
#'   - `<stbl-error-size_too_large>` when the vector is longer than `max_size`.
#'   - `<stbl-error-fct_levels>` when values are not present in `levels`.
#' @family factor functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_fct(letters)
#' try(stabilize_fct(NULL, allow_null = FALSE))
#' try(stabilize_fct(c("a", NA), allow_na = FALSE))
#' try(stabilize_fct(c("a", "b", "c"), min_size = 5))
#' try(stabilize_fct(c("a", "b", "c"), max_size = 2))
stabilize_fct <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls(
    x,
    to_cls_fn = to_fct,
    to_cls_args = list(levels = levels, to_na = to_na),
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
#' @rdname stabilize_fct
stabilize_factor <- stabilize_fct

#' @export
#' @rdname stabilize_fct
stabilise_fct <- stabilize_fct

#' @export
#' @rdname stabilize_fct
stabilise_factor <- stabilize_fct

#' Coerce to length-1 factor with additional checks
#'
#' Checks whether a vector can be coerced to a length-1 factor.
#' `stabilize_fct_scalar()` is optimized to check for length-1 factors
#' (compared to [stabilize_fct()] with `max_size = 1`). `stabilise_fct_scalar`,
#' `stabilize_factor_scalar()`, and `stabilise_factor_scalar` are synonyms of
#' `stabilize_fct_scalar()`.
#'
#' @inheritParams .shared-params
#' @param levels `(character)` Expected levels. If `NULL` (default), the levels
#'   will be computed by [base::factor()].
#'
#' @returns The input as a length-1 factor, or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-factor>` when `x` cannot be coerced to factor.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#'   - `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.
#'   - `<stbl-error-fct_levels>` when values are not present in `levels`.
#' @family factor functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' stabilize_fct_scalar("a")
#' try(stabilize_fct_scalar(letters))
#' try(stabilize_fct_scalar("c", levels = c("a", "b")))
stabilize_fct_scalar <- function(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stabilize_cls_scalar(
    x,
    to_cls_scalar_fn = to_fct_scalar,
    to_cls_scalar_args = list(levels = levels, to_na = to_na),
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
#' @rdname stabilize_fct_scalar
stabilize_factor_scalar <- stabilize_fct_scalar

#' @export
#' @rdname stabilize_fct_scalar
stabilise_fct_scalar <- stabilize_fct_scalar

#' @export
#' @rdname stabilize_fct_scalar
stabilise_factor_scalar <- stabilize_fct_scalar
