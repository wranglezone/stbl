#' Check if an object can be safely coerced to a function
#'
#' @description `are_fn_ish()` is a vectorized predicate function that checks
#'   whether each element of its input can be safely coerced to a function.
#'   `are_function_ish()` is a synonym of `are_fn_ish()`.
#'
#'   `is_fn_ish()` is a scalar predicate that checks whether its input can be
#'   safely coerced to a function by [to_fn()]. `is_function_ish()` is a
#'   synonym of `is_fn_ish()`.
#'
#' @details
#' `are_fn_ish()` returns `TRUE` for:
#' - Functions (including lambda functions created with `~` or `\()`)
#' - Formulas (one-sided or two-sided, coercible via [rlang::as_function()])
#' - Character strings that are syntactically valid function names: either a
#'   bare name (`"mean"`) or a namespaced name (`"pkg::fn"`). The check is
#'   syntactic; it does not verify that the named function exists in any
#'   environment.
#'
#' `is_fn_ish()` returns `TRUE` for objects that [to_fn()] can coerce without
#' error (assuming a matching function exists in the search path):
#' - Functions (including lambda functions created with `~` or `\()`)
#' - One-sided or two-sided formulas
#' - Single non-`NA` character strings (including namespaced `"pkg::fn"` names)
#'
#' `NULL` and length-0 character vectors are *not* considered function-ish
#' because they do not represent a callable object; [to_fn()] converts them to
#' `NULL` only as a permissive special case controlled by `allow_null`.
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#' @returns `are_fn_ish()` returns a logical vector with the same length as the
#'   input. `is_fn_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`).
#' @family function functions
#' @family check functions
#' @export
#'
#' @examples
#' are_fn_ish(mean)
#' are_fn_ish(~ . + 1)
#' are_fn_ish(c("mean", "stats::median", NA, "", "1bad"))
#' are_fn_ish(NULL)
#' are_fn_ish(1L)
#'
#' is_fn_ish(mean)
#' is_fn_ish("mean")
#' is_fn_ish("stats::median")
#' is_fn_ish(~ . + 1)
#' is_fn_ish(NULL)
#' is_fn_ish(1L)
are_fn_ish <- function(x, ...) {
  UseMethod("are_fn_ish")
}

#' @export
#' @rdname are_fn_ish
are_function_ish <- are_fn_ish

#' @export
#' @rdname are_fn_ish
is_fn_ish <- function(x, ...) {
  if (is.function(x) || rlang::is_formula(x)) {
    return(TRUE)
  }
  if (rlang::is_string(x) && !is.na(x)) {
    return(isTRUE(.Call(stbl_chr_are_fnish, x)))
  }
  FALSE
}

#' @export
#' @rdname are_fn_ish
is_function_ish <- is_fn_ish

#' @export
are_fn_ish.function <- function(x, ...) {
  TRUE
}

#' @export
are_fn_ish.formula <- function(x, ...) {
  TRUE
}

#' @export
are_fn_ish.character <- function(x, ...) {
  .Call(stbl_chr_are_fnish, x)
}

#' @export
are_fn_ish.NULL <- function(x, ...) {
  logical(0)
}

#' @export
are_fn_ish.default <- function(x, ...) {
  FALSE
}
