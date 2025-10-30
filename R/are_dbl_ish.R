#' Check if an object can be safely coerced to double
#'
#' @description `are_dbl_ish()` is a vectorized predicate function that checks
#' whether each element of its input can be safely coerced to a double vector.
#' `are_double_ish()` is a synonym of `are_dbl_ish()`.
#'
#' `is_dbl_ish()` is a scalar predicate function that checks if all elements of
#' its input can be safely coerced to a double vector. `is_double_ish()` is a
#' synonym of `is_dbl_ish()`.
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `are_dbl_ish()` returns a logical vector with the same length as the
#'   input. `is_dbl_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`) for
#'   the entire vector.
#' @family double functions
#' @family check functions
#' @export
#'
#' @examples
#' are_dbl_ish(c(1.0, 2.2, 3.14))
#' is_dbl_ish(c(1.0, 2.2, 3.14))
#'
#' are_dbl_ish(1:3)
#' is_dbl_ish(1:3)
#'
#' are_dbl_ish(c("1.1", "2.2", NA))
#' is_dbl_ish(c("1.1", "2.2", NA))
#'
#' are_dbl_ish(c("a", "1.0"))
#' is_dbl_ish(c("a", "1.0"))
#'
#' are_dbl_ish(list(1, "2.2", "c"))
#' is_dbl_ish(list(1, "2.2", "c"))
#'
#' are_dbl_ish(c(1 + 1i, 1 + 0i, NA))
#' is_dbl_ish(c(1 + 1i, 1 + 0i, NA))
are_dbl_ish <- function(x, ...) {
  UseMethod("are_dbl_ish")
}

#' @export
#' @rdname are_dbl_ish
is_dbl_ish <- function(x, ...) {
  all(are_dbl_ish(x, ...))
}

#' @export
#' @rdname are_dbl_ish
are_double_ish <- are_dbl_ish

#' @export
#' @rdname are_dbl_ish
is_double_ish <- is_dbl_ish

#' @export
are_dbl_ish.double <- function(x, ...) {
  rep(TRUE, length(x))
}

#' @export
are_dbl_ish.integer <- function(x, ...) {
  rep(TRUE, length(x))
}

#' @export
are_dbl_ish.NULL <- function(x, ...) {
  logical(0)
}

#' @export
are_dbl_ish.logical <- function(x, ...) {
  rep(TRUE, length(x))
}

#' @export
#' @rdname are_dbl_ish
are_dbl_ish.character <- function(x, ..., coerce_character = TRUE) {
  if (!to_lgl_scalar(coerce_character)) {
    return(rep(FALSE, length(x)))
  }

  !.are_not_dbl_ish_chr(x)
}

#' Check for character to double coercion failures
#'
#' @inheritParams .shared-params-check
#' @returns A logical vector where `TRUE` indicates a failure.
#' @keywords internal
.are_not_dbl_ish_chr <- function(x) {
  cast_dbl <- suppressWarnings(as.double(x))
  x_na <- is.na(x)
  xor(x_na, is.na(cast_dbl))
}


#' @export
#' @rdname are_dbl_ish
are_dbl_ish.factor <- function(x, ..., coerce_factor = TRUE) {
  if (!to_lgl_scalar(coerce_factor)) {
    return(rep(FALSE, length(x)))
  }
  are_dbl_ish(as.character(x), ...)
}

#' @export
are_dbl_ish.complex <- function(x, ...) {
  # The imaginary part must be zero. The real part is already a double.
  is.na(x) | (Im(x) == 0)
}

#' @export
#' @rdname are_dbl_ish
are_dbl_ish.default <- function(x, ..., depth = 1) {
  if (!rlang::is_vector(x) || depth != 1) {
    return(FALSE)
  }
  .elements_are_cls_ish(x, are_dbl_ish, ...)
}
