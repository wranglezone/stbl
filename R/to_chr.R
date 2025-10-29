#' @export
#' @rdname stabilize_chr
to_chr <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_chr")
}

#' @export
#' @rdname stabilize_chr
to_character <- to_chr

#' @export
to_chr.character <- function(x, ...) {
  return(x)
}

#' @export
#' @rdname stabilize_chr
to_chr.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
to_chr.list <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_from_list(
    x,
    to_chr,
    "character",
    ...,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
to_chr.data.frame <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stop_cant_coerce(
    from_class = x_class,
    to_class = "character",
    x_arg = x_arg,
    call = call
  )
}

#' @export
to_chr.default <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  try_fetch(
    as.character(x),
    error = function(cnd) {
      .stop_cant_coerce(
        from_class = x_class,
        to_class = "character",
        x_arg = x_arg,
        call = call
      )
    }
  )
}

#' @export
#' @rdname stabilize_chr
to_chr_scalar <- function(
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
    is_rlang_cls_scalar = is_scalar_character,
    to_cls_fn = to_chr,
    to_cls_args = list(...),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname stabilize_chr
to_character_scalar <- to_chr_scalar
