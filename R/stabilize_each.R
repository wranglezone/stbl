#' Ensure every element of x satisfies a single spec
#'
#' `stabilize_each()` applies `spec` (a `to_*` function, `stabilize_*`
#' function, or `specify_*()` result) to every element of `x` independently,
#' collecting *every* failing location before erroring, rather than stopping
#' at the first failure like [to_each()]. `stabilise_each()` is a synonym.
#'
#' @inheritParams .shared-params
#'
#' @returns `x` with every element coerced by `spec`, simplified to an atomic
#'   vector when `simplify = TRUE` and possible, otherwise a list. Errors with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and `<stbl-error-cant_stabilize_each>` when any element
#'   fails `spec`; the condition's `locations` element gives the positions
#'   that failed.
#' @family multiple type functions
#' @export
#'
#' @examples
#' stabilize_each(list("1", "2", "3"), stabilize_int)
#' stabilize_each(list(1L, 2L, 3L), stabilize_chr)
#'
#' # Elements that can't be simplified into a common type stay a list
#' stabilize_each(list(1L, "a"), specify_any_of(specify_int(), specify_chr()))
#'
#' # Reports every failing location, not just the first
#' try(stabilize_each(list("1", "a", "b"), stabilize_int))
stabilize_each <- function(
  x,
  spec,
  ...,
  simplify = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  force(x_arg)
  force(call)
  check_dots_empty0(...)
  if (!length(x)) {
    return(x)
  }
  simplify <- to_lgl_scalar(simplify, call = call)
  result <- .map_each_safe(x, spec, x_arg = x_arg, call = call)
  failed <- !vapply(result$errors, is.null, logical(1))
  locations <- which(failed)
  if (length(locations)) {
    .stop_cant_stabilize_each(
      errors = result$errors[locations],
      locations = locations,
      x_arg = x_arg,
      x_class = x_class,
      call = call
    )
  }
  .simplify_each(result$out, simplify = simplify)
}

#' @export
#' @rdname stabilize_each
stabilise_each <- stabilize_each
