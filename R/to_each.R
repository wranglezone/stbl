#' Coerce each element of x with a single spec
#'
#' `to_each()` applies `spec` (a `to_*` function, `stabilize_*` function, or
#' `specify_*()` result) to every element of `x`, and stops at the first
#' element that fails. When every result has size 1 and shares a common type,
#' the results are simplified into a single atomic vector; otherwise a list is
#' returned.
#'
#' @inheritParams .shared-params
#'
#' @returns `x` with every element coerced by `spec`, simplified to an atomic
#'   vector when `simplify = TRUE` and possible, otherwise a list. Errors with
#'   whatever condition `spec` throws for the first failing element.
#' @family multiple type functions
#' @export
#'
#' @examples
#' to_each(list("1", "2", "3"), to_int)
#' to_each(list(1L, 2L, 3L), to_chr)
#'
#' # Elements that can't be simplified into a common type stay a list
#' to_each(list(1L, "a"), specify_any_of(specify_int(), specify_chr()))
#'
#' # Stops at the first element that fails
#' try(to_each(list("1", "a"), to_int))
to_each <- function(
  x,
  spec,
  ...,
  simplify = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
) {
  force(x_arg)
  force(call)
  check_dots_empty0(...)
  if (!length(x)) {
    return(x)
  }
  simplify <- to_lgl_scalar(simplify, call = call)
  out <- .map_each_fast(x, spec, x_arg = x_arg, call = call)
  .simplify_each(out, simplify = simplify)
}
