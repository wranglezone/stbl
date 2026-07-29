#' Try to coerce or validate x as one of several types
#'
#' `stabilize_one_of()` attempts to validate and coerce `x` using each
#' function in `...` in order. It returns the result of the first function
#' that succeeds. If all functions fail, an informative error that combines the
#' individual failure messages is thrown. `stabilise_one_of()` is a synonym.
#'
#' `to_one_of()` is analogous to [to()]: it tries to coerce `x` to each type
#' given in `...` (as a prototype such as `integer()` or `character()`) and
#' returns the first successful result.
#'
#' @param ... For `stabilize_one_of()`: unnamed stabilizer or coercion
#'   functions, such as `stabilize_*` functions ([stabilize_chr()], etc.),
#'   `to_*` functions ([to_chr()], etc.), or functions produced by `specify_*()`
#'   calls ([specify_chr()], etc.). For `to_one_of()`: prototype objects (e.g.
#'   `integer()`, `character()`) that determine the target types to try, passed
#'   as the `.to` argument of [to()].
#' @inheritParams .shared-params
#'
#' @returns `x` coerced or validated by the first successful function or
#'   prototype in `...`.
#' @family stabilization functions
#' @export
#'
#' @examples
#' # Returns x unchanged when the first function succeeds
#' stabilize_one_of(1L, stabilize_int, stabilize_chr)
#'
#' # Falls through to stabilize_chr when stabilize_int fails
#' stabilize_one_of("a", stabilize_int, stabilize_chr)
#'
#' # Coerces via the first matching function ("1" -> 1L)
#' stabilize_one_of("1", stabilize_int, stabilize_chr)
#'
#' # Errors with a combined message when all functions fail
#' try(stabilize_one_of(list(), stabilize_int, stabilize_chr))
stabilize_one_of <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  force(x_arg)
  force(call)

  fns <- list(...)
  .check_specs_not_empty(fns, .call = call)
  .check_specs_unnamed(fns, .call = call)

  .try_fns(x, fns = fns, x_arg = x_arg, call = call)
}

#' @export
#' @rdname stabilize_one_of
stabilise_one_of <- stabilize_one_of

#' @rdname stabilize_one_of
#' @export
#'
#' @examples
#' # to_one_of() uses prototypes instead of functions
#' to_one_of(1L, integer(), character())
#' to_one_of("a", integer(), character())
#' to_one_of("1", integer(), character())
#' try(to_one_of(list(), integer(), character()))
to_one_of <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  force(x_arg)
  force(call)

  protos <- list(...)
  .check_specs_not_empty(protos, .call = call)

  errors <- list()
  for (proto in protos) {
    result <- rlang::try_fetch(
      to(x, proto, x_arg = x_arg, call = call, x_class = x_class),
      error = function(cnd) cnd
    )
    if (!inherits(result, "error")) {
      return(result)
    }
    errors <- c(errors, list(result))
  }

  .stop_cant_stabilize_one_of(errors = errors, x_arg = x_arg, call = call)
}

# helpers ----

#' Check that a specs list is non-empty
#'
#' @param fns `(list)` The list of functions or prototypes passed via `...`.
#' @inheritParams stabilize_lst
#' @returns `NULL`, invisibly, if the list is non-empty.
#' @keywords internal
.check_specs_not_empty <- function(fns, .call = caller_env()) {
  if (length(fns)) {
    return(invisible(NULL))
  }
  .stbl_abort(
    c(
      "At least one function must be provided via `...`.",
      i = "Supply stabilizer functions, or prototypes for `to_one_of()`."
    ),
    subclass = "empty_specs",
    call = .call
  )
}

#' Check that all specs passed via ... are unnamed
#'
#' @param fns `(list)` The list of functions passed via `...`.
#' @inheritParams stabilize_lst
#' @returns `NULL`, invisibly, if all elements are unnamed.
#' @keywords internal
.check_specs_unnamed <- function(fns, .call = caller_env()) {
  if (!length(fns)) {
    return(invisible(NULL)) # nocov
  }
  nms <- names(fns) %||% character(length(fns))
  if (any(nms != "")) {
    .stbl_abort(
      c(
        "All elements passed via `...` must be unnamed.",
        i = "Functions are applied to `x` in sequence, not by name."
      ),
      subclass = "named_spec",
      call = .call
    )
  }
  invisible(NULL)
}

#' Try each function in sequence, returning the first success
#'
#' @param x The value to test.
#' @param fns `(list)` The list of stabilizer or coercion functions to try.
#' @inheritParams stabilize_lst
#' @returns The result of the first function that does not throw an error.
#' @keywords internal
.try_fns <- function(x, fns, x_arg, call) {
  errors <- list()
  for (fn in fns) {
    result <- rlang::try_fetch(
      .call_specified_fn(fn, x, .x_arg = x_arg, .call = call),
      error = function(cnd) cnd
    )
    if (!inherits(result, "error")) {
      return(result)
    }
    errors <- c(errors, list(result))
  }
  .stop_cant_stabilize_one_of(errors = errors, x_arg = x_arg, call = call)
}

#' Signal a combined error when no function succeeds
#'
#' @param errors `(list)` List of error conditions from failed attempts.
#' @inheritParams stabilize_lst
#' @returns Does not return; throws an error.
#' @keywords internal
.stop_cant_stabilize_one_of <- function(errors, x_arg, call) {
  # Take the first line of each error message to avoid deeply nested output.
  first_lines <- vapply(
    errors,
    \(e) {
      strsplit(conditionMessage(e), "\n")[[1L]][[1L]]
    },
    character(1L)
  )
  additional_msg <- stats::setNames(first_lines, rep("x", length(first_lines)))
  .stop_must(
    "must match at least one of the provided stabilizers.",
    x_arg = x_arg,
    additional_msg = additional_msg,
    call = call,
    subclass = "cant_stabilize_one_of"
  )
}
