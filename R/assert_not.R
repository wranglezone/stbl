#' Require a value not to match a specification
#'
#' `assert_not()` is the inverse of a single specification: it errors when `x`
#' **would** be accepted by `spec`, and returns `x` unchanged otherwise. Under
#' Postel's law, "would be accepted" means "would coerce" — so
#' `assert_not("1", specify_int())` errors because `"1"` is int-ish, even
#' though it isn't literally an integer.
#'
#' Because `assert_*()` functions return their input unchanged, they compose
#' cleanly with the `stabilize_*_of()` family ([stabilize_any_of()],
#' [stabilize_one_of()], [stabilize_all_of()]): wrap `assert_not()` in a
#' function that forwards `x_arg`/`call` and pass it alongside other specs to
#' require that `x` is *not* something, in addition to other constraints.
#'
#' @param spec A single stabilizer function, `to_*` function, or
#'   `specify_*()` result that `x` must **not** match.
#' @param ... Reserved for future use; must be empty.
#' @inheritParams .shared-params
#' @returns `x`, unchanged, if `x` does not match `spec`, or an error
#'   condition with classes `<stbl-error>`, `<stbl-condition>`,
#'   `<rlang_error>`, `<error>`, `<condition>`, and
#'   `<stbl-error-matched_spec>` when `x` matches `spec`.
#' @family stabilization functions
#' @export
#'
#' @examples
#' assert_not("a", specify_int())
#' assert_not(1.5, stabilize_int)
#'
#' # Errors because "1" is int-ish, even though it isn't literally an integer
#' try(assert_not("1", specify_int()))
#'
#' # Errors because stabilize_int() succeeds outright on 1L
#' try(assert_not(1L, stabilize_int))
assert_not <- function(
  x,
  spec,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  force(x_arg)
  force(call)

  spec_quo <- rlang::enquo(spec)
  check_dots_empty0(..., call = call)

  fn <- rlang::eval_tidy(spec_quo)
  attempt <- rlang::try_fetch(
    .call_specified_fn(fn, x, .x_arg = x_arg, .call = call),
    error = function(cnd) cnd
  )
  if (!inherits(attempt, "error")) {
    .stop_matched_spec(
      spec_label = rlang::as_label(spec_quo),
      x_arg = x_arg,
      call = call
    )
  }
  x
}

# helpers ----

#' Signal an error when x matches a spec forbidden by assert_not()
#'
#' @param spec_label `(character(1))` A label for the spec that `x` matched,
#'   used in the error message.
#' @inheritParams stabilize_lst
#' @returns Does not return; throws an error.
#' @keywords internal
.stop_matched_spec <- function(spec_label, x_arg, call) {
  .stop_must(
    "must not match {.val {spec_label}}.",
    x_arg = x_arg,
    call = call,
    subclass = "matched_spec",
    message_env = rlang::current_env()
  )
}
