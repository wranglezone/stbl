# target class: NA

#' Convert each element of x with a single spec
#'
#' `to_each()` applies `spec` (a `to_*` function, `stabilize_*` function, or
#' `specify_*()` result) to every element of `x`, and stops at the first element
#' that fails.
#'
#' @inheritParams .shared-params
#'
#' @returns `x` with every element converted by `spec`, simplified to an atomic
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

#' Apply a spec to each element of x, failing on the first error
#'
#' @param spec A single stabilizer/conversion function applied to each element.
#' @inheritParams stabilize_each
#' @returns A list of per-element results, the same length as `x`.
#' @keywords internal
.map_each_fast <- function(x, spec, x_arg, call) {
  n <- length(x)
  out <- vector("list", n)
  out <- .name_like(out, x)
  for (i in seq_len(n)) {
    element_arg <- paste0(x_arg, "[[", i, "]]")
    out[[i]] <- .call_specified_fn(
      spec,
      x[[i]],
      .x_arg = element_arg,
      .call = call
    )
  }
  out
}
