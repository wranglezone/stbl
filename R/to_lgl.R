#' Coerce to logical
#'
#' Checks whether a vector can be coerced to logical without losing information,
#' returning it silently if so. Otherwise an informative error message is
#' signaled. `to_logical` is a synonym of `to_lgl()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a logical vector, or an error condition with classes
#'   `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-logical>` when `x` cannot be coerced to logical.
#'   - `<stbl-error-incompatible_values-logical>` when some values cannot be
#'   safely converted to logical.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
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
to_lgl <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_lgl")
}

#' @export
#' @rdname to_lgl
to_logical <- to_lgl

#' @export
to_lgl.logical <- function(x, ...) {
  return(x)
}

#' @export
#' @rdname to_lgl
to_lgl.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
to_lgl.numeric <- function(x, ...) {
  .Call(stbl_dbl_to_lgl, x)[["result"]]
}

#' @export
to_lgl.character <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  res <- .Call(stbl_chr_to_lgl, x)
  failures <- !res[["valid"]]
  .check_cast_failures(
    x,
    failures,
    x_class,
    logical(),
    "unexpected strings (should be 'TRUE', 'FALSE', 'T', 'F', or an integer)",
    x_arg,
    call
  )

  return(res[["result"]])
}

#' @export
to_lgl.factor <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  res <- .Call(stbl_fct_to_lgl, x)
  failures <- !res[["valid"]]
  .check_cast_failures(
    x,
    failures,
    x_class,
    logical(),
    "unexpected strings (should be 'TRUE', 'FALSE', 'T', 'F', or an integer)",
    x_arg,
    call
  )
  return(res[["result"]])
}

#' @export
to_lgl.list <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  res <- .Call(stbl_lst_to_lgl, x)
  .check_lst_failures(x, res[["valid"]], logical(), x_class, x_arg, call)
  res[["result"]]
}

#' @export
to_lgl.default <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stop_cant_coerce(
    from_class = x_class,
    to_class = "logical",
    x_arg = x_arg,
    call = call
  )
}

#' Coerce to length-1 logical
#'
#' Checks whether a vector can be coerced to a length-1 logical vector.
#' `to_logical_scalar()` is a synonym of `to_lgl_scalar()`.
#'
#' @inheritParams .shared-params
#'
#' @returns The input as a length-1 logical vector, or an error condition
#'   with classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`,
#'   `<error>`, `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-coerce-logical>` when `x` cannot be coerced to logical.
#'   - `<stbl-error-incompatible_values-logical>` when some values cannot be
#'   safely converted to logical.
#'   - `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.
#'   - `<stbl-error-bad_empty>` for empty vectors when
#'   `allow_zero_length = FALSE`.
#'   - `<stbl-error-non_scalar>` for non-scalar vectors.
#' @family logical functions
#' @family stabilization functions
#' @export
#'
#' @examples
#' to_lgl_scalar("TRUE")
#' try(to_lgl_scalar(c(TRUE, FALSE)))
to_lgl_scalar <- function(
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
    is_rlang_cls_scalar = is_scalar_logical,
    to_cls_fn = to_lgl,
    to_cls_args = list(...),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to_lgl_scalar
to_logical_scalar <- to_lgl_scalar
