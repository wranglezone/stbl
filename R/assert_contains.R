#' Require that x contains a number of elements matching a specification
#'
#' `assert_contains()` counts how many elements of `x` match a single `spec`,
#' and requires that count to fall between `min_matches` and `max_matches`
#' (inclusive). It returns `x` unchanged if the count is within bounds, and
#' errors otherwise.
#'
#' `spec` is applied to `x` as a whole (not element-by-element), reusing the
#' `locations`-reporting machinery used by `stabilize_*()` functions: if
#' `spec` succeeds outright, every element of `x` counts as a match; if `spec`
#' fails and the resulting condition carries a `locations` element (as most
#' `{stbl}` failures do), every element *not* in `locations` counts as a
#' match; if `spec` fails without a `locations` element, no elements count as
#' matches.
#'
#' @param min_matches (`integer(1)`) The minimum number of elements of `x`
#'   that must match `spec`. Must be `>= 1`.
#' @param max_matches (`integer(1)` or `NULL`) The maximum number of elements
#'   of `x` that may match `spec`. Must be `>= min_matches`. `NULL` (default)
#'   skips the upper-bound check.
#' @inheritParams .shared-params
#' @returns `x`, unchanged, if the number of elements of `x` matching `spec`
#'   is between `min_matches` and `max_matches`, or an error condition with
#'   classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
#'   `<condition>`, and a specific class by failure mode:
#'   - `<stbl-error-too_few_matches>` when fewer than `min_matches` elements
#'   match `spec`.
#'   - `<stbl-error-too_many_matches>` when more than `max_matches` elements
#'   match `spec`.
#' @family stabilization functions
#' @export
#'
#' @examples
#' # By default, at least 1 element must match spec
#' assert_contains(list("1", "a", "b"), stabilize_int)
#'
#' # Require at least 2 matching elements
#' assert_contains(list("1", "2", "a"), stabilize_int, min_matches = 2)
#'
#' # Errors because no elements are int-ish
#' try(assert_contains(list("a", "b"), stabilize_int))
#'
#' # Errors because too many elements are int-ish
#' try(assert_contains(list("1", "2", "3"), stabilize_int, max_matches = 2))
assert_contains <- function(
  x,
  spec,
  ...,
  min_matches = 1,
  max_matches = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  force(x_arg)
  force(call)

  spec_quo <- rlang::enquo(spec)
  check_dots_empty0(..., call = call)

  min_matches <- stabilize_int_scalar(
    min_matches,
    min_value = 1,
    x_arg = "min_matches",
    call = call
  )
  max_matches <- to_int_scalar(max_matches, allow_null = TRUE, call = call)
  if (!is.null(max_matches)) {
    max_matches <- stabilize_int_scalar(
      max_matches,
      min_value = min_matches,
      x_arg = "max_matches",
      call = call
    )
  }

  fn <- rlang::eval_tidy(spec_quo)
  matched_locations <- .find_spec_matches(x, fn, x_arg = x_arg, call = call)

  .check_match_count(
    matched_locations,
    min_matches = min_matches,
    max_matches = max_matches,
    x_arg = x_arg,
    x_class = x_class,
    call = call
  )

  x
}

# helpers ----

#' Find which elements of x match a spec applied to x as a whole
#'
#' @param x The object to test.
#' @param fn A stabilizer or coercion function, applied to `x` as a whole.
#' @inheritParams stabilize_lst
#' @returns An integer vector of positions in `x` that match `fn`.
#' @keywords internal
.find_spec_matches <- function(x, fn, x_arg, call) {
  attempt <- rlang::try_fetch(
    .call_specified_fn(fn, x, .x_arg = x_arg, .call = call),
    error = function(cnd) cnd
  )
  n <- length(x)
  if (!inherits(attempt, "error")) {
    return(seq_len(n))
  }
  failing <- attempt$locations
  if (is.null(failing)) {
    return(integer())
  }
  setdiff(seq_len(n), failing)
}

#' Signal an error when the match count falls outside min_matches/max_matches
#'
#' @param matched_locations `(integer)` Positions in `x` that matched `spec`.
#' @inheritParams stabilize_lst
#' @returns `NULL`, invisibly, if the match count is within bounds.
#' @keywords internal
.check_match_count <- function(
  matched_locations,
  min_matches,
  max_matches,
  x_arg,
  x_class,
  call
) {
  n_matches <- length(matched_locations)
  if (n_matches < min_matches) {
    .stop_must(
      "{.cls {x_class}} must contain at least {min_matches} element{?s} matching {.arg spec}.",
      x_arg = x_arg,
      additional_msg = c(x = "Found {n_matches} matching element{?s}."),
      call = call,
      subclass = "too_few_matches",
      message_env = rlang::current_env(),
      locations = matched_locations
    )
  }
  if (!is.null(max_matches) && n_matches > max_matches) {
    .stop_must(
      "{.cls {x_class}} must contain at most {max_matches} element{?s} matching {.arg spec}.",
      x_arg = x_arg,
      additional_msg = c(x = "Found {n_matches} matching element{?s}."),
      call = call,
      subclass = "too_many_matches",
      message_env = rlang::current_env(),
      locations = matched_locations
    )
  }
  invisible(NULL)
}
