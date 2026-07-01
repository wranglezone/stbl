#' Convert a value to a target type
#'
#' `to()` is a drop-in replacement for [vctrs::vec_cast()]. It coerces `x` to
#' the type of `.to`, dispatching on the class of `.to` and delegating to the
#' appropriate `to_*()` function so that the full argument set (e.g.,
#' `coerce_character`, `levels`, `to_na`) is available via `...`.
#'
#' @details The `stbl_to()` C function is also part of stbl's public C API
#'   (`inst/include/stbl.h`), allowing packages like tibblify to call it from
#'   their own C code as a fast alternative to `vctrs::vec_cast()`.
#'
#' @param .to A prototype that determines the target type (e.g.,
#'   `integer()`, `factor(levels = c("a", "b"))`).
#' @inheritParams .shared-params
#'
#' @returns `x` coerced to the type of `.to`.
#' @family character functions
#' @family double functions
#' @family integer functions
#' @family logical functions
#' @family factor functions
#' @family list functions
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
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to", .to)
}

#' @export
#' @rdname to
to.logical <- function(
  x,
  .to,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  if (is.null(x)) {
    return(.to_null(x, allow_null = allow_null, x_arg = x_arg, call = call))
  }
  to_lgl(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.integer <- function(
  x,
  .to,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  if (is.null(x)) {
    return(.to_null(x, allow_null = allow_null, x_arg = x_arg, call = call))
  }
  to_int(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.numeric <- function(
  x,
  .to,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  if (is.null(x)) {
    return(.to_null(x, allow_null = allow_null, x_arg = x_arg, call = call))
  }
  to_dbl(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.character <- function(
  x,
  .to,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  if (is.null(x)) {
    return(.to_null(x, allow_null = allow_null, x_arg = x_arg, call = call))
  }
  to_chr(x, ..., x_arg = x_arg, call = call, x_class = x_class)
}

#' @export
#' @rdname to
to.factor <- function(
  x,
  .to,
  ...,
  levels = NULL,
  to_na = character(),
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  if (is.null(x)) {
    return(.to_null(x, allow_null = allow_null, x_arg = x_arg, call = call))
  }
  levels <- levels %||% levels(.to)
  to_fct(
    x,
    ...,
    levels = levels,
    to_na = to_na,
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
  allow_null = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  if (is.null(x)) {
    return(.to_null(x, allow_null = allow_null, x_arg = x_arg, call = call))
  }
  to_lst(x, ..., x_arg = x_arg, call = call)
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
