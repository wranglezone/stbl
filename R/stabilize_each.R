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

# helpers shared by to_each() and stabilize_each() ----

#' Copy x's names onto out, leaving out unnamed if x has none
#'
#' @param out `(list)` The object to name.
#' @inheritParams stabilize_each
#' @returns `out`, named like `x` when `x` has any names.
#' @keywords internal
.name_like <- function(out, x) {
  nms <- rlang::names2(x)
  if (any(nzchar(nms))) {
    names(out) <- nms
  }
  out
}

#' Apply a spec to each element of x, collecting every failure
#'
#' @inheritParams .map_each_fast
#' @returns A list with elements:
#'   - `out`: per-element results (`NULL` at any failing location).
#'   - `errors`: per-element error conditions (`NULL` at any successful
#'   location).
#' @keywords internal
.map_each_safe <- function(x, spec, x_arg, call) {
  n <- length(x)
  out <- vector("list", n)
  out <- .name_like(out, x)
  errors <- vector("list", n)
  for (i in seq_len(n)) {
    element_arg <- paste0(x_arg, "[[", i, "]]")
    result <- rlang::try_fetch(
      .call_specified_fn(spec, x[[i]], .x_arg = element_arg, .call = call),
      error = function(cnd) cnd
    )
    if (inherits(result, "error")) {
      errors[[i]] <- result
    } else {
      out[[i]] <- result
    }
  }
  list(out = out, errors = errors)
}

#' Simplify a list of per-element results into a common-type vector
#'
#' Combines `out` into an atomic vector when every element has size 1 and a
#' common type can be found; otherwise `out` is returned unchanged.
#'
#' @param out `(list)` Per-element results, such as produced by
#'   [.map_each_fast()] or the `out` element of [.map_each_safe()]'s result.
#' @inheritParams stabilize_each
#' @returns `out`, simplified to an atomic vector when possible.
#' @keywords internal
.simplify_each <- function(out, simplify) {
  if (!simplify || !length(out)) {
    return(out)
  }
  sizes <- vapply(out, vctrs::vec_size, integer(1))
  if (any(sizes != 1L)) {
    return(out)
  }
  ptype <- tryCatch(
    rlang::inject(vctrs::vec_ptype_common(!!!unname(out))),
    error = function(cnd) NULL
  )
  if (is.null(ptype)) {
    return(out)
  }
  result <- rlang::inject(vctrs::vec_c(!!!unname(out), .ptype = ptype))
  nms <- names(out)
  if (any(nzchar(nms))) {
    names(result) <- nms
  }
  result
}

#' Signal a combined error when any element fails its spec
#'
#' @param errors `(list)` Error conditions for each failing location, in the
#'   same order as `locations`.
#' @param locations `(integer)` Positions in `x` that failed.
#' @inheritParams stabilize_each
#' @returns Does not return; throws an error.
#' @keywords internal
.stop_cant_stabilize_each <- function(errors, locations, x_arg, x_class, call) {
  msgs <- vapply(errors, .extract_stabilizer_msg, character(1L))
  additional_msg <- stats::setNames(
    paste0("Location ", locations, ": ", msgs),
    rep("x", length(msgs))
  )
  .stop_must(
    msg = "{.cls {x_class}} must have every element satisfy {.arg spec}.",
    x_arg = x_arg,
    additional_msg = additional_msg,
    call = call,
    subclass = "cant_stabilize_each",
    message_env = rlang::current_env(),
    locations = locations
  )
}
