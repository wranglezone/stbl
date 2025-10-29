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
to_dbl.integer <- function(x, ..., x_arg = caller_arg(x), call = caller_env()) {
  vctrs::vec_cast(x, double(), x_arg = x_arg, call = call)
}

#' @export
to_dbl.logical <- function(x, ..., x_arg = caller_arg(x), call = caller_env()) {
  vctrs::vec_cast(x, double(), x_arg = x_arg, call = call)
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
    allow_null = FALSE,
    call = call
  )
  if (coerce_character) {
    failures <- .are_not_dbl_ish_chr(x)
    .check_cast_failures(
      failures,
      x_class,
      double(),
      "incompatible values",
      x_arg,
      call
    )
    return(suppressWarnings(as.double(x)))
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
  .to_cls_from_fct(
    x,
    to_cls_fn = to_dbl,
    to_cls_args = list(...),
    to_class = "double",
    coerce_factor = coerce_factor,
    x_arg = x_arg,
    call = call,
    x_class = x_class
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
  .to_num_from_complex(
    x,
    cast_fn = as.double,
    to_type_obj = double(),
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
to_dbl.default <- function(x, ..., x_arg = caller_arg(x), call = caller_env()) {
  vctrs::vec_cast(x, double(), x_arg = x_arg, call = call)
}

#' @export
#' @rdname stabilize_dbl
to_dbl_scalar <- function(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
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
