#' @export
#' @rdname stabilize_lgl
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
#' @rdname stabilize_lgl
to_logical <- to_lgl

#' @export
to_lgl.logical <- function(x, ...) {
  return(x)
}

#' @export
#' @rdname stabilize_lgl
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
to_lgl.numeric <- function(x, ..., x_arg = caller_arg(x), call = caller_env()) {
  return(as.logical(x))
}

#' @export
to_lgl.character <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  failures <- !are_lgl_ish.character(x)
  .check_cast_failures(
    failures,
    x_class,
    logical(),
    "incompatible values",
    x_arg,
    call
  )

  res <- as.logical(toupper(x))
  not_coerced <- is.na(res) & !is.na(x)
  res[not_coerced] <- as.logical(to_dbl(
    x[not_coerced],
    x_arg = x_arg,
    call = call,
    x_class = x_class,
    ...
  ))

  return(res)
}

#' @export
to_lgl.factor <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  return(
    to_lgl.character(
      as.character(x),
      ...,
      x_arg = x_arg,
      call = call,
      x_class = x_class
    )
  )
}

#' @export
to_lgl.list <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_from_list(
    x,
    to_lgl,
    "logical",
    ...,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
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

#' @export
#' @rdname stabilize_lgl
to_lgl_scalar <- function(
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
#' @rdname stabilize_lgl
to_logical_scalar <- to_lgl_scalar
