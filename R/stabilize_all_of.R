#' Try to coerce or validate x as all of several specs
#'
#' `stabilize_all_of()` validates and coerces `x` by applying every function in
#' `...` to `x`, independently. `x` must satisfy every spec, and all specs must
#' agree on the coerced result; if any spec fails, or specs disagree on the
#' coerced value, an informative error is thrown. `stabilise_all_of()` is a
#' synonym.
#'
#' @param ... Unnamed stabilizer functions, such as `stabilize_*` functions
#'   ([stabilize_chr()], etc.), `to_*` functions ([to_chr()], etc.), or
#'   functions produced by `specify_*()` calls ([specify_chr()], etc.). Each is
#'   applied to the original `x`; `x` must pass every one of them, and they must
#'   all return the same value.
#' @inheritParams .shared-params
#'
#' @returns `x` coerced or validated by every function in `...`, or an error
#'   condition with classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`,
#'   `<error>`, `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-empty_specs>` when no functions are supplied in `...`.
#'   - `<stbl-error-named_spec>` when any element of `...` is named.
#'   - `<stbl-error-cant_stabilize_all_of>` when any provided function fails.
#'   - `<stbl-error-inconsistent_all_of>` when every function succeeds, but
#'   they don't all produce the same coerced value.
#' @family stabilization functions
#' @export
#'
#' @examples
#' # Returns x unchanged when all functions succeed
#' stabilize_all_of(1L, stabilize_int, stabilize_int_scalar)
#'
#' # Each spec is applied to the original x, independently
#' stabilize_all_of("ab", specify_chr(regex = "^a"), specify_chr(regex = "b$"))
#'
#' # Errors with a combined message when a spec fails
#' try(stabilize_all_of("a", stabilize_int, stabilize_chr))
#'
#' # Errors because each spec sees the original "1" (a string); the second
#' # spec would succeed on 1L, but doesn't get the chance to see it
#' try(stabilize_all_of("1", stabilize_int, specify_dbl(coerce_character = FALSE)))
#'
#' # Errors when specs succeed but disagree on the coerced value
#' # (stabilize_int() keeps 1L an integer; specify_dbl() makes it a double)
#' try(stabilize_all_of(1L, stabilize_int, specify_dbl()))
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

  result <- NULL
  for (i in seq_along(fns)) {
    fn_result <- rlang::try_fetch(
      .call_specified_fn(fns[[i]], x, .x_arg = x_arg, .call = call),
      error = function(cnd) cnd
    )
    if (inherits(fn_result, "error")) {
      .stop_cant_stabilize_all_of(error = fn_result, x_arg = x_arg, call = call)
    }
    if (i == 1L) {
      result <- fn_result
    } else if (!identical(result, fn_result)) {
      .stop_inconsistent_all_of(x_arg = x_arg, call = call)
    }
  }

  result
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

#' Signal an error when specs in stabilize_all_of() disagree
#'
#' @inheritParams stabilize_lst
#' @returns Does not return; throws an error.
#' @keywords internal
.stop_inconsistent_all_of <- function(x_arg, call) {
  .stop_must(
    "must be coerced the same way by every provided stabilizer.",
    x_arg = x_arg,
    additional_msg = c(
      i = "The provided stabilizers succeeded, but disagreed on the coerced value."
    ),
    call = call,
    subclass = "inconsistent_all_of",
    message_env = rlang::current_env()
  )
}
