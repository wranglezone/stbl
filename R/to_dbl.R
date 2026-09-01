#' Coerce to double
#'
#' Checks whether a vector can be coerced to double without losing information,
#' returning it silently if so. Otherwise an informative error message is
#' signaled. `to_double` is a synonym of `to_dbl()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a double vector, or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-double>` when `x` cannot be coerced to double.
#'   - `<stbl-error-incompatible_values-double>` when some values cannot be
#'   safely converted to double.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
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
to_dbl <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_dbl")
}

#' @export
#' @rdname to_dbl
to_double <- to_dbl

#' @export
to_dbl.double <- function(x, ...) {
  return(x)
}

#' @export
#' @rdname to_dbl
to_dbl.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
to_dbl.list <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  res <- .Call(stbl_lst_to_dbl, x)
  .check_lst_failures(x, res[["valid"]], double(), x_class, x_arg, call)
  res[["result"]]
}

#' @export
to_dbl.integer <- function(x, ...) {
  .Call(stbl_int_to_dbl, x)[["result"]]
}

#' @export
to_dbl.logical <- function(x, ...) {
  .Call(stbl_lgl_to_dbl, x)[["result"]]
}

#' @export
#' @rdname to_dbl
to_dbl.character <- function(
  x,
  ...,
  coerce_character = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  coerce_character <- to_lgl_scalar(
    coerce_character,
    call = call
  )
  if (coerce_character) {
    res <- .Call(stbl_chr_to_dbl, x)
    .check_cast_failures(
      x,
      !res[["valid"]],
      x_class,
      double(),
      "non-numeric strings",
      x_arg,
      call
    )
    return(res[["result"]])
  }
  .stop_cant_coerce(
    from_class = x_class,
    to_class = "double",
    x_arg = x_arg,
    call = call
  )
}

#' @export
#' @rdname to_dbl
to_dbl.factor <- function(
  x,
  ...,
  coerce_factor = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  coerce_factor <- to_lgl_scalar(coerce_factor, call = call)
  if (coerce_factor) {
    res <- .Call(stbl_fct_to_dbl, x)
    .check_cast_failures(
      x,
      !res[["valid"]],
      x_class,
      double(),
      "non-numeric strings",
      x_arg,
      call
    )
    return(res[["result"]])
  }
  .stop_cant_coerce(
    from_class = x_class,
    to_class = "double",
    x_arg = x_arg,
    call = call
  )
}

#' @export
to_dbl.complex <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  res <- .Call(stbl_cpx_to_dbl, x)
  .check_cast_failures(
    x,
    !res[["valid"]],
    x_class,
    double(),
    "non-zero complex components",
    x_arg,
    call
  )
  return(res[["result"]])
}

#' @export
to_dbl.default <- function(x, ..., x_arg = caller_arg(x), call = caller_env()) {
  vctrs::vec_cast(x, double(), x_arg = x_arg, call = call)
}

#' Coerce to length-1 double
#'
#' Checks whether a vector can be coerced to a length-1 double vector.
#' `to_double_scalar()` is a synonym of `to_dbl_scalar()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a length-1 double vector, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-double>` when `x` cannot be coerced to double.
#'   - `<stbl-error-incompatible_values-double>` when some values cannot be
#'   safely converted to double.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#' @family double functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_dbl_scalar("1.1")
#' try(to_dbl_scalar(1:10))
to_dbl_scalar <- function(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_scalar(
    x,
    is_rlang_cls_scalar = rlang::is_scalar_double,
    to_cls_fn = to_dbl,
    to_cls_args = list(...),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to_dbl_scalar
to_double_scalar <- to_dbl_scalar
