#' Check if an object can be safely coerced to logical
#'
#' @description
#' `are_lgl_ish()` is a vectorized predicate function that checks whether each
#' element of its input can be safely coerced to a logical vector.
#'
#' `is_lgl_ish()` is a scalar predicate function that checks if all elements of
#' its input can be safely coerced to a logical vector.
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `are_lgl_ish()` returns a logical vector with the same length as the
#'   input. `is_lgl_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`) for
#'   the entire vector.
#' @family logical functions
#' @family check functions
#' @export
#'
#' @examples
#' are_lgl_ish(c(TRUE, FALSE, NA))
#' is_lgl_ish(c(TRUE, FALSE, NA))
#'
#' are_lgl_ish(c(1, 0, 1.0, NA))
#' is_lgl_ish(c(1, 0, 1.0, NA))
#'
#' are_lgl_ish(c("T", "F", "TRUE", "FALSE", "true", "false", "1", "0"))
#' is_lgl_ish(c("T", "F", "TRUE", "FALSE", "true", "false", "1", "0"))
#'
#' are_lgl_ish(c("T", "F", "a", "1.1"))
#' is_lgl_ish(c("T", "F", "a", "1.1"))
#'
#' are_lgl_ish(factor(c("T", "a")))
#' is_lgl_ish(factor(c("T", "a")))
#'
#' are_lgl_ish(list(TRUE, 0, "F", "a"))
#' is_lgl_ish(list(TRUE, 0, "F", "a"))
are_lgl_ish <- function(x, ...) {
  UseMethod("are_lgl_ish")
}

#' @export
#' @rdname are_lgl_ish
is_lgl_ish <- function(x, ...) {
  all(are_lgl_ish(x, ...))
}

#' @export
#' @rdname are_lgl_ish
are_logical_ish <- are_lgl_ish

#' @export
#' @rdname are_lgl_ish
is_logical_ish <- is_lgl_ish

#' @export
are_lgl_ish.logical <- function(x, ...) {
  rep(TRUE, length(x))
}

#' @export
are_lgl_ish.NULL <- function(x, ...) {
  logical(0)
}

#' @export
are_lgl_ish.numeric <- function(x, ...) {
  rep(TRUE, length(x))
}

#' @export
are_lgl_ish.character <- function(x, ...) {
  cast <- as.logical(toupper(x))
  !xor(is.na(x), is.na(cast)) | are_dbl_ish(x, ...)
}

#' @export
are_lgl_ish.factor <- function(x, ...) {
  are_lgl_ish(as.character(x), ...)
}

#' @export
#' @rdname are_lgl_ish
are_lgl_ish.default <- function(x, ..., depth = 1) {
  if (!rlang::is_vector(x) || depth != 1) {
    return(FALSE)
  }
  .elements_are_cls_ish(x, are_lgl_ish, ...)
}
