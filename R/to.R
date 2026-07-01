#' Convert a value to a target type
#'
#' `to()` is a fast drop-in replacement for [vctrs::vec_cast()]. It coerces
#' `x` to the type of `.to`, dispatching on the class of `.to` and calling the
#' appropriate `to_*()` function.
#'
#' @details For factor and list targets, `to()` delegates to [to_fct()] and
#'   [to_lst()] respectively so that their full argument sets (e.g., `levels`,
#'   `to_na`) are available via `...`. For logical, integer, double, and
#'   character targets, conversion is performed directly in C via `stbl_to()`
#'   for maximum speed.
#'
#'   The `stbl_to()` C function is also part of stbl's public C API
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
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  UseMethod("to", .to)
}

#' @export
#' @rdname to
to.factor <- function(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  to_fct(
    x,
    ...,
    levels = levels(.to),
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
to.default <- function(x, .to, ...) {
  # Primitive types (lgl, int, dbl, chr): fast C dispatch
  .Call(stbl_to, x, .to)
}
