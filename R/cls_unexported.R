#' Coerce an object to a specific scalar class
#'
#' A helper that wraps around a `to_*_scalar()` function to provide a standard
#' set of checks.
#'
#' @inheritParams .shared-params
#' @returns `x` as a scalar of the target class.
#' @keywords internal
.to_cls_scalar <- function(
  x,
  is_rlang_cls_scalar,
  to_cls_fn,
  to_cls_args = list(),
  allow_null = TRUE,
  allow_zero_length = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  if (is_rlang_cls_scalar(x)) {
    return(x)
  }

  force(x_arg)
  force(call)
  x <- inject(
    to_cls_fn(
      x,
      allow_null = allow_null,
      !!!to_cls_args,
      x_arg = x_arg,
      call = call,
      x_class = x_class
    )
  )
  .check_scalar(
    x,
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = class(x)
  )
  return(x)
}

#' Stabilize an object of a specific class
#'
#' A helper used by the `stabilize_*()` functions to provide a standard set of
#' checks.
#'
#' @inheritParams .shared-params
#' @returns `x` as a vector of the target class with all checks passed.
#' @keywords internal
.stabilize_cls <- function(
  x,
  to_cls_fn,
  ...,
  to_cls_args = list(),
  check_cls_value_fn = NULL,
  check_cls_value_fn_args = list(),
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  force(x_arg)
  force(call)
  x <- inject(
    to_cls_fn(
      x,
      allow_null = allow_null,
      !!!to_cls_args,
      x_arg = x_arg,
      call = call,
      x_class = x_class
    )
  )
  if (!is.null(check_cls_value_fn)) {
    inject(
      check_cls_value_fn(
        x,
        !!!check_cls_value_fn_args,
        x_arg = x_arg,
        call = call
      )
    )
  }
  stabilize_arg(
    x = x,
    ...,
    allow_null = allow_null,
    allow_na = allow_na,
    min_size = min_size,
    max_size = max_size,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' Stabilize a scalar object of a specific class
#'
#' A helper used by the `stabilize_*_scalar()` functions to provide a standard
#' set of checks.
#'
#' @inheritParams .shared-params
#' @returns `x` as a scalar of the target class with all checks passed.
#' @keywords internal
.stabilize_cls_scalar <- function(
  x,
  to_cls_scalar_fn,
  ...,
  to_cls_scalar_args = list(),
  check_cls_value_fn = NULL,
  check_cls_value_fn_args = list(),
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  check_dots_empty0(..., call = call)
  force(x_arg)
  force(call)

  x <- inject(
    to_cls_scalar_fn(
      x,
      allow_null = allow_null,
      allow_zero_length = allow_zero_length,
      !!!to_cls_scalar_args,
      x_arg = x_arg,
      call = call,
      x_class = x_class
    )
  )
  if (!is.null(check_cls_value_fn)) {
    inject(
      check_cls_value_fn(
        x,
        !!!check_cls_value_fn_args,
        x_arg = x_arg,
        call = call
      )
    )
  }
  .check_na(x, allow_na = allow_na, x_arg = x_arg, call = call)
  return(x)
}

#' Check if all elements of a list-like object are ish
#'
#' @inheritParams .shared-params-check
#' @keywords internal
.elements_are_cls_ish <- function(x, are_cls_ish_fn, ...) {
  vapply(
    unname(x),
    function(elem) {
      elem <- unlist(elem)
      rlang::is_scalar_atomic(elem) && are_cls_ish_fn(elem, ..., depth = 2)
    },
    logical(1)
  )
}

#' Coerce an object from a factor to a specific class
#'
#' A helper that wraps around a `to_*()` function to provide a standard way to
#' coerce factors.
#'
#' @inheritParams .shared-params
#' @returns `x` coerced to the target class.
#' @keywords internal
.to_cls_from_fct <- function(
  x,
  to_cls_fn,
  to_cls_args,
  to_class,
  coerce_factor = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  coerce_factor <- to_lgl_scalar(coerce_factor, call = call)
  if (coerce_factor) {
    return(
      rlang::inject(
        to_cls_fn(
          as.character(x),
          !!!to_cls_args,
          x_arg = x_arg,
          call = call,
          x_class = x_class
        )
      )
    )
  }
  .stop_cant_coerce(
    from_class = x_class,
    to_class = to_class,
    x_arg = x_arg,
    call = call
  )
}

#' Coerce an object from a complex to a numeric class
#'
#' A helper that wraps around a `to_*()` function to provide a standard way to
#' coerce complex numbers.
#'
#' @inheritParams .shared-params
#' @returns `x` coerced to the target class.
#' @keywords internal
.to_num_from_complex <- function(
  x,
  cast_fn,
  to_type_obj,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  cast <- suppressWarnings(cast_fn(x))
  x_na <- is.na(x)
  failures <- (cast != x & !x_na) | xor(x_na, is.na(cast))
  .check_cast_failures(
    failures,
    x_class,
    to_type_obj,
    "non-zero complex components",
    x_arg,
    call
  )
  return(cast)
}

#' Coerce a list to a specific class
#'
#' @inheritParams .shared-params
#' @returns `x` coerced to the target class.
#' @keywords internal
.to_cls_from_list <- function(
  x,
  to_cls_fn,
  to_class,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  flat <- unlist(x)
  if (!is.list(flat) && length(flat) == length(x)) {
    return(to_cls_fn(flat, ..., x_arg = x_arg, call = call, x_class = x_class))
  }
  .stop_cant_coerce(
    from_class = x_class,
    to_class = to_class,
    x_arg = x_arg,
    call = call
  )
}
