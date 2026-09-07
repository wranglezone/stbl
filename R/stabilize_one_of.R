#' Try to coerce or validate x as exactly one of several specifications
#'
#' @description `stabilize_one_of()` evaluates every function in `...`
#'   against `x` and requires that exactly one of them succeeds. It returns
#'   the result of that single successful function. If zero functions
#'   succeed, an informative error that combines the individual failure
#'   messages is thrown; if two or more functions succeed, an error naming
#'   the specifications that matched is thrown. `stabilise_one_of()` is a
#'   synonym.
#'
#'   `to_one_of()` is analogous to [to()]: it tries to coerce `x` to each type
#'   given in `...` (as a prototype such as `integer()` or `character()`) and
#'   requires that exactly one succeeds.
#'
#' @param ... For `stabilize_one_of()`: unnamed stabilizer or coercion
#'   functions, such as `stabilize_*` functions ([stabilize_chr()], etc.),
#'   `to_*` functions ([to_chr()], etc.), functions produced by `specify_*()`
#'   calls ([specify_chr()], etc.), or `assert_*()` functions (such as
#'   [assert_not()]) that return their input unchanged. For `to_one_of()`:
#'   prototype objects (e.g.
#'   `integer()`, `character()`) that determine the target types to try, passed
#'   as the `.to` argument of [to()].
#' @inheritParams .shared-params
#'
#' @returns `x` coerced or validated by the single successful function or
#'   prototype in `...`, or an error condition with classes `<stbl-error>`,
#'   `<stbl-condition>`, `<rlang_error>`, `<error>`, `<condition>`, and a
#'   specific class by failure mode:
#'   - `<stbl-error-empty_specs>` when no functions are supplied in `...`.
#'   - `<stbl-error-named_spec>` when any element of `...` is named.
#'   - `<stbl-error-cant_stabilize_one_of>` when zero, or more than one,
#'   provided functions succeed.
#' @family stabilization functions
#' @export
#'
#' @examples
#' # Returns x unchanged when exactly one function succeeds
#' stabilize_one_of("a", stabilize_int, stabilize_chr)
#'
#' # Coerces via the single matching function (1.5 can't become an integer)
#' stabilize_one_of(1.5, stabilize_int, stabilize_chr)
#'
#' # Errors as ambiguous: "1" is both int-ish and dbl-ish
#' try(stabilize_one_of("1", stabilize_int, stabilize_dbl))
#'
#' # Errors with a combined message when no function succeeds
#' try(stabilize_one_of(list(1, TRUE, "23", "maybe"), stabilize_lgl, stabilize_int))
stabilize_one_of <- function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
) {
  force(x_arg)
  force(call)

  quos <- rlang::enquos(...)
  .check_specs_not_empty(quos, .call = call)
  .check_specs_unnamed(quos, .call = call)

  fns <- lapply(quos, rlang::eval_tidy)
  labels <- vapply(quos, rlang::as_label, character(1L))

  .try_exactly_one(
    fns,
    run_one = function(fn) {
      .call_specified_fn(fn, x, .x_arg = x_arg, .call = call)
    },
    labels = labels,
    x_arg = x_arg,
    call = call
  )
}

#' @export
#' @rdname stabilize_one_of
stabilise_one_of <- stabilize_one_of

# helpers ----

#' Try every item, requiring exactly one to succeed
#'
#' @param items `(list)` The specifications to try (functions or prototypes).
#' @param run_one `(function)` A function taking a single item from `items`
#'   and returning its result for `x`, throwing an error on failure.
#' @param labels `(character)` A label for each item in `items`, used to
#'   identify matched specifications in the "more than one" error message.
#' @inheritParams stabilize_lst
#' @returns The result of the single item that does not throw an error.
#' @keywords internal
.try_exactly_one <- function(items, run_one, labels, x_arg, call) {
  errors <- list()
  matched <- character()
  matched_at <- integer()
  for (i in seq_along(items)) {
    attempt <- rlang::try_fetch(
      run_one(items[[i]]),
      error = function(cnd) cnd
    )
    if (inherits(attempt, "error")) {
      errors <- c(errors, list(attempt))
    } else {
      matched <- c(matched, labels[[i]])
      matched_at <- c(matched_at, i)
      result <- attempt
    }
  }
  if (length(matched) == 1L) {
    return(result)
  }
  .stop_cant_stabilize_one_of(
    errors = errors,
    matched = matched,
    matched_at = matched_at,
    x_arg = x_arg,
    call = call
  )
}

#' Format matched specification labels for an error message
#'
#' When two or more matched labels are identical (e.g. the same function or
#' prototype passed more than once via `...`), appends each label's position
#' in `...` so the matches can be told apart; otherwise returns `matched`
#' unchanged, letting the caller quote it with `{.val {matched}}`.
#'
#' @param matched `(character)` Labels of the specifications that succeeded.
#' @param matched_at `(integer)` Positions in `...` of the specifications
#'   that succeeded, parallel to `matched`.
#' @returns A character vector, pre-quoted with position suffixes if `matched`
#'   contains duplicates, or `matched` itself otherwise.
#' @keywords internal
.label_matched_specs <- function(matched, matched_at) {
  if (!anyDuplicated(matched)) {
    return(cli::format_inline("{.val {matched}}"))
  }
  quoted <- vapply(
    matched,
    function(label) cli::format_inline("{.val {label}}"),
    character(1L)
  )
  paste0(quoted, " (", matched_at, ")")
}

#' Signal an error when zero, or more than one, specs match in
#' stabilize_one_of()/to_one_of()
#'
#' @param errors `(list)` List of error conditions from failed attempts. Only
#'   used when `matched` is empty.
#' @param matched `(character)` Labels of the specifications that succeeded.
#'   Only used when there are two or more.
#' @param matched_at `(integer)` Positions in `...` of the specifications that
#'   succeeded, parallel to `matched`. Used to disambiguate `matched` labels
#'   that are identical (e.g. the same function passed more than once).
#' @inheritParams stabilize_lst
#' @returns Does not return; throws an error.
#' @keywords internal
.stop_cant_stabilize_one_of <- function(
  errors,
  matched,
  matched_at,
  x_arg,
  call
) {
  if (length(matched) >= 2L) {
    labeled <- .label_matched_specs(matched, matched_at)
    .stop_must(
      "must match exactly one of the provided specifications, but matched {length(matched)}.",
      x_arg = x_arg,
      additional_msg = c(i = "Matched specifications: {labeled}"),
      call = call,
      subclass = "cant_stabilize_one_of",
      message_env = rlang::current_env()
    )
  }
  msgs <- unique(vapply(errors, .extract_stabilizer_msg, character(1L)))
  additional_msg <- stats::setNames(msgs, rep("x", length(msgs)))
  .stop_must(
    "must match exactly one of the provided specifications, but matched none.",
    x_arg = x_arg,
    additional_msg = additional_msg,
    call = call,
    subclass = "cant_stabilize_one_of"
  )
}
