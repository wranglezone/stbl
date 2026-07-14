#' Check if an object can be safely coerced to a function
#'
#' `is_fn_ish()` is a predicate function that checks whether its input can be
#' safely coerced to a function by [to_fn()]. `is_function_ish()` is a synonym
#' of `is_fn_ish()`.
#'
#' @details
#' `is_fn_ish()` returns `TRUE` for objects that [to_fn()] can coerce without
#' error (assuming a matching function exists in the search path):
#'
#' - Functions (including lambda functions created with `~` or `\()`)
#' - Single non-`NA` character strings (including namespaced `"pkg::fn"` names)
#' - One-sided or two-sided formulas (coerced via [rlang::as_function()])
#'
#' `NULL` and length-0 character vectors are *not* considered function-ish
#' because they do not represent a callable object; [to_fn()] converts them to
#' `NULL` only as a permissive special case controlled by `allow_null`.
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#' @returns A `length-1 logical` (`TRUE` or `FALSE`).
#' @family function functions
#' @family check functions
#' @export
#'
#' @examples
#' is_fn_ish(mean)
#' is_fn_ish("mean")
#' is_fn_ish("stats::median")
#' is_fn_ish(~ . + 1)
#' is_fn_ish(NULL)
#' is_fn_ish(1L)
is_fn_ish <- function(x, ...) {
  is.function(x) || (rlang::is_string(x) && !is.na(x)) || rlang::is_formula(x)
}

#' @export
#' @rdname is_fn_ish
is_function_ish <- is_fn_ish
