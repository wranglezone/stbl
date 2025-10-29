#' @export
#' @rdname stabilize_int
to_int <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to_int")
}

#' @export
#' @rdname stabilize_int
to_integer <- to_int

#' @export
to_int.integer <- function(x, ...) {
  return(x)
}

#' @export
#' @rdname stabilize_int
to_int.NULL <- function(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  .to_null(x, allow_null = allow_null, x_arg = x_arg, call = call)
}

#' @export
to_int.list <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_from_list(
    x,
    to_int,
    "integer",
    ...,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
to_int.double <- function(x, ..., x_arg = caller_arg(x), call = caller_env()) {
  vec_cast(x, integer(), x_arg = x_arg, call = call)
}

#' @export
to_int.logical <- function(x, ..., x_arg = caller_arg(x), call = caller_env()) {
  vec_cast(x, integer(), x_arg = x_arg, call = call)
}

#' @export
#' @rdname stabilize_int
to_int.character <- function(
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
    .check_chr_to_int_failures(x, x_class, x_arg, call)
    return(suppressWarnings(as.integer(x)))
  }
  .stop_cant_coerce(
    from_class = x_class,
    to_class = "integer",
    x_arg = x_arg,
    call = call
  )
}

#' @export
#' @rdname stabilize_int
to_int.factor <- function(
  x,
  ...,
  coerce_factor = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_cls_from_fct(
    x,
    to_cls_fn = to_int,
    to_cls_args = list(...),
    to_class = "integer",
    coerce_factor = coerce_factor,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
to_int.complex <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_num_from_complex(
    x,
    cast_fn = as.integer,
    to_type_obj = integer(),
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
to_int.default <- function(x, ..., x_arg = caller_arg(x), call = caller_env()) {
  vec_cast(x, integer(), x_arg = x_arg, call = call)
}

#' @export
#' @rdname stabilize_int
to_int_scalar <- function(
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
    is_rlang_cls_scalar = is_scalar_integer,
    to_cls_fn = to_int,
    to_cls_args = list(...),
    allow_null = allow_null,
    allow_zero_length = allow_zero_length,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname stabilize_int
to_integer_scalar <- to_int_scalar

#' Check for character to integer coercion failures
#'
#' @inheritParams .shared-params
#'
#' @returns `NULL`, invisibly, if `x` passes all checks.
#' @keywords internal
.check_chr_to_int_failures <- function(x, x_class, x_arg, call) {
  failures <- .are_not_int_ish_chr(x)
  if (!any(failures)) {
    return(invisible(NULL))
  }
  .check_cast_failures(
    failures[, "non_number"],
    x_class,
    integer(),
    "incompatible values",
    x_arg,
    call
  )
  .stop_incompatible(
    x_class,
    integer(),
    failures[, "bad_precision"],
    due_to = "loss of precision",
    x_arg,
    call
  )
}
