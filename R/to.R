#' Convert a value to a target type
#'
#' `to()` coerces `x` to the type of `.to`, dispatching on the class of `.to`
#' to the appropriate `to_*()` function.
#'
#' @param .to A prototype that determines the target type (e.g., `integer()`,
#'   `factor(levels = c("a", "b"))`).
#' @param ... Arguments passed to methods and on to `to_*()` functions.
#' @inheritParams .shared-params
#'
#' @returns `x` coerced to the type of `.to`.
#' @family character functions
#' @family double functions
#' @family integer functions
#' @family logical functions
#' @family factor functions
#' @family list functions
#' @family data frame functions
#' @export
#'
#' @examples
#' to(1L, double())
#' to(1.0, integer())
#' to(TRUE, character())
#' to("1", integer())
#' to(c("a", "b"), factor(levels = c("a", "b", "c")))
to <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to", .to)
}

#' @export
#' @rdname to
to.character <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_chr(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.double <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_dbl(
    x,
    ...,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to
to.data.frame <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_df(x, ..., x_arg = x_arg, call = call)
}

#' @export
#' @rdname to
to.factor <- function(
  x,
  .to,
  ...,
  levels = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  levels <- levels %||% levels(.to)
  to_fct(
    x,
    ...,
    levels = levels,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to
to.integer <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_int(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.logical <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_lgl(
    x,
    ...,
    x_arg = x_arg,
    call = call,
    x_class = x_class
  )
}

#' @export
#' @rdname to
to.list <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_lst(x, ..., x_arg = x_arg, call = call)
}

#' @export
#' @rdname to
to.NULL <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .to_null(x, ..., x_arg = x_arg, call = call)
}

#' @export
#' @rdname to
to.default <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  .stop_cant_coerce(
    from_class = x_class,
    to_class = object_type(.to),
    x_arg = x_arg,
    call = call
  )
}
