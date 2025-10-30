#' Check if an object can be safely coerced to integer
#'
#' @description `are_int_ish()` is a vectorized predicate function that checks
#'   whether each element of its input can be safely coerced to an integer
#'   vector. `are_integer_ish()` is a synonym of `are_int_ish()`.
#'
#'   `is_int_ish()` is a scalar predicate function that checks if all elements
#'   of its input can be safely coerced to an integer vector. `is_integer_ish()`
#'   is a synonym of `is_int_ish()`.
#'
#' @inheritParams .shared-params-check
#' @inheritParams .shared-params
#'
#' @returns `are_int_ish()` returns a logical vector with the same length as the
#'   input. `is_int_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`) for
#'   the entire vector.
#' @family integer functions
#' @family check functions
#' @export
#'
#' @examples
#' are_int_ish(1:4)
#' is_int_ish(1:4)
#'
#' are_int_ish(c(1.0, 2.0, 3.00000))
#' is_int_ish(c(1.0, 2.0, 3.00000))
#'
#' are_int_ish(c("1.0", "2.0", "3.00000"))
#' is_int_ish(c("1.0", "2.0", "3.00000"))
#'
#' are_int_ish(c(1, 2.2, NA))
#' is_int_ish(c(1, 2.2, NA))
#'
#' are_int_ish(c("1", "1.0", "1.1", "a"))
#' is_int_ish(c("1", "1.0", "1.1", "a"))
#'
#' are_int_ish(factor(c("1", "a")))
#' is_int_ish(factor(c("1", "a")))
are_int_ish <- function(x, ...) {
  UseMethod("are_int_ish")
}

#' @export
#' @rdname are_int_ish
is_int_ish <- function(x, ...) {
  all(are_int_ish(x, ...))
}

#' @export
#' @rdname are_int_ish
are_integer_ish <- are_int_ish

#' @export
#' @rdname are_int_ish
is_integer_ish <- is_int_ish

#' @export
are_int_ish.integer <- function(x, ...) {
  rep(TRUE, length(x))
}

#' @export
are_int_ish.NULL <- function(x, ...) {
  logical(0)
}

#' @export
are_int_ish.double <- function(x, ...) {
  is.na(x) | (!is.infinite(x) & (x == floor(x)))
}

#' @export
are_int_ish.logical <- function(x, ...) {
  rep(TRUE, length(x))
}

#' @export
#' @rdname are_int_ish
are_int_ish.character <- function(x, ..., coerce_character = TRUE) {
  if (!to_lgl_scalar(coerce_character)) {
    return(rep(FALSE, length(x)))
  }

  failures <- .are_not_int_ish_chr(x)
  unname(!apply(failures, 1, any))
}

#' Check for character to integer coercion failures
#'
#' @inheritParams .shared-params-check
#' @returns A logical matrix with two columns: `non_number` and `bad_precision`.
#' @keywords internal
.are_not_int_ish_chr <- function(x) {
  cast_int <- suppressWarnings(as.integer(x))
  cast_dbl <- suppressWarnings(as.double(x))
  x_na <- is.na(x)
  cbind(
    non_number = .are_not_dbl_ish_chr(x),
    bad_precision = cast_int != cast_dbl & !x_na
  )
}

#' @export
#' @rdname are_int_ish
are_int_ish.factor <- function(x, ..., coerce_factor = TRUE) {
  if (!to_lgl_scalar(coerce_factor)) {
    return(rep(FALSE, length(x)))
  }
  are_int_ish(as.character(x), ...)
}

#' @export
are_int_ish.complex <- function(x, ...) {
  # The imaginary part must be zero, and the real part must be int-ish.
  are_dbl_ish(x, ...) & are_int_ish(Re(x), ...)
}

#' @export
#' @rdname are_int_ish
are_int_ish.default <- function(x, ..., depth = 1) {
  if (!rlang::is_vector(x) || depth != 1) {
    return(FALSE)
  }
  .elements_are_cls_ish(x, are_int_ish, ...)
}
