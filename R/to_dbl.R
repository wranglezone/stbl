#' @export
#' @rdname stabilize_dbl
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
#' @rdname stabilize_dbl
to_double <- to_dbl

#' @export
to_dbl.double <- function(x, ...) {
  return(x)
}

#' @export
#' @rdname stabilize_dbl
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
  .to_cls_from_list(
    x,
    to_dbl,
    "double",
    ...,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
to_dbl.integer <- function(x, ...) {
  .Call(stbl_int_to_dbl, x)
}

#' @export
to_dbl.logical <- function(x, ...) {
  .Call(stbl_lgl_to_dbl, x)
}

#' @export
#' @rdname stabilize_dbl
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
    res <- .Call(ffi_chr_to_dbl, x)
    .check_cast_failures(
      !res[["valid"]],
      x_class,
      double(),
      "incompatible values",
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
#' @rdname stabilize_dbl
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
    res <- .Call(ffi_fct_to_dbl, x)
    .check_cast_failures(
      !res[["valid"]],
      x_class,
      double(),
      "incompatible values",
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
  res <- .Call(ffi_cpx_to_dbl, x)
  .check_cast_failures(
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
  vec_cast(x, double(), x_arg = x_arg, call = call)
}

#' @export
#' @rdname stabilize_dbl
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
#' @rdname stabilize_dbl
to_double_scalar <- to_dbl_scalar
