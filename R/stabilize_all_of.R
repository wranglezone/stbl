#' Try to coerce or validate x as all of several specs
#'
#' @description `stabilize_all_of()` validates and coerces `x` by applying
#'   each function in `...` in order, feeding the result of each spec into the
#'   next. `x` must satisfy every spec; if any spec fails, an informative
#'   error is thrown. `stabilise_all_of()` is a synonym.
#'
#'   Because specs are applied in sequence and each may coerce `x`, order
#'   matters: `stabilize_all_of(x, spec_a, spec_b)` first stabilizes `x` with
#'   `spec_a`, then passes *that* result to `spec_b`. There is no `to_all_of()`
#'   counterpart, because it doesn't make sense to match more than one
#'   prototype at once.
#'
#' @param ... Unnamed stabilizer functions, such as `stabilize_*` functions
#'   ([stabilize_chr()], etc.), `to_*` functions ([to_chr()], etc.), or
#'   functions produced by `specify_*()` calls ([specify_chr()], etc.). Applied
#'   to `x` in order; the output of each becomes the input to the next.
#' @inheritParams .shared-params
#'
#' @returns `x` coerced or validated by every function in `...`, applied in
#'   sequence, or an error condition with classes `<stbl-error>`,
#'   `<stbl-condition>`, `<rlang_error>`, `<error>`, `<condition>`, and a
#'   specific class by failure mode:
#'   - `<stbl-error-empty_specs>` when no functions are supplied in `...`.
#'   - `<stbl-error-named_spec>` when any element of `...` is named.
#'   - `<stbl-error-cant_stabilize_all_of>` when any provided function fails.
#' @family stabilization functions
#' @export
#'
#' @examples
#' # Returns x unchanged when all functions succeed
#' stabilize_all_of(1L, stabilize_int, stabilize_dbl)
#'
#' # Specs are applied in order, each fed the previous result ("1" -> 1L -> 1)
#' stabilize_all_of("1", stabilize_int, stabilize_dbl)
#'
#' # Errors with a combined message when a spec fails
#' try(stabilize_all_of("a", stabilize_int, stabilize_dbl))
#'
#' # Errors when an earlier spec's result fails a later spec
#' try(stabilize_all_of(1L, stabilize_int, specify_dbl(min_value = 10)))
stabilize_all_of <- function(
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

  for (fn in fns) {
    result <- rlang::try_fetch(
      .call_specified_fn(fn, x, .x_arg = x_arg, .call = call),
      error = function(cnd) cnd
    )
    if (inherits(result, "error")) {
      .stop_cant_stabilize_all_of(error = result, x_arg = x_arg, call = call)
    }
    x <- result
  }

  x
}

#' @export
#' @rdname stabilize_all_of
stabilise_all_of <- stabilize_all_of

# helpers ----

#' Signal an error when a spec fails in stabilize_all_of()
#'
#' @param error `(error condition)` The error thrown by the failing spec.
#' @inheritParams stabilize_lst
#' @returns Does not return; throws an error.
#' @keywords internal
.stop_cant_stabilize_all_of <- function(error, x_arg, call) {
  msg <- .extract_stabilizer_msg(error)
  additional_msg <- stats::setNames(msg, "x")
  .stop_must(
    "must match all of the provided stabilizers.",
    x_arg = x_arg,
    additional_msg = additional_msg,
    call = call,
    subclass = "cant_stabilize_all_of"
  )
}
