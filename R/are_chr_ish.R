#' Check if an object can be safely coerced to character
#'
#' @description
#' `are_chr_ish()` is a vectorized predicate function that checks whether each
#' element of its input can be safely coerced to a character vector.
#'
#' `is_chr_ish()` is a scalar predicate function that checks if all elements of
#' its input can be safely coerced to a character vector.
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `are_chr_ish()` returns a logical vector with the same length as the
#'   input. `is_chr_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`) for
#'   the entire vector.
#' @family character functions
#' @family check functions
#' @export
#'
#' @examples
#' are_chr_ish(letters)
#' is_chr_ish(letters)
#'
#' are_chr_ish(1:10)
#' is_chr_ish(1:10)
#'
#' are_chr_ish(list("a", 1, TRUE))
#' is_chr_ish(list("a", 1, TRUE))
#'
#' are_chr_ish(list("a", 1, list(1, 2)))
#' is_chr_ish(list("a", 1, list(1, 2)))
are_chr_ish <- function(x, ...) {
  UseMethod("are_chr_ish")
}

#' @export
#' @rdname are_chr_ish
is_chr_ish <- function(x, ...) {
  all(are_chr_ish(x, ...))
}

#' @export
are_chr_ish.character <- function(x, ...) {
  rep(TRUE, length(x))
}

#' @export
are_chr_ish.NULL <- function(x, ...) {
  logical(0)
}

#' @export
#' @rdname are_chr_ish
are_chr_ish.default <- function(x, ..., depth = 1) {
  if (rlang::is_atomic(x)) {
    return(rep(TRUE, length(x)))
  }
  if (!rlang::is_vector(x) || depth != 1) {
    return(FALSE)
  }
  .elements_are_cls_ish(x, are_chr_ish, ...)
}
