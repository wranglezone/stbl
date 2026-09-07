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

#' Apply a spec to each element of x, failing on the first error
#'
#' @param spec A single stabilizer/coercion function applied to each element.
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
