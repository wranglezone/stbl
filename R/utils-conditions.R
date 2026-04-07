#' Compile a condition class chain
#'
#' @param ... `(character)` Components of the class name, from least-specific to
#'   most.
#' @inheritParams .shared-params
#' @returns A character vector.
#' @keywords internal
.compile_pkg_condition_classes <- function(package, ...) {
  dots <- unlist(list(...))
  accumulated <- vector("character", length = length(dots))
  for (i in seq_along(dots)) {
    accumulated[[i]] <- .compile_dash(package, .collapse_dash(dots[seq_len(i)]))
  }
  c(rev(accumulated), .compile_dash(package, "condition"))
}

#' Paste together with - separator
#'
#' @param ... Things to paste.
#' @returns A length-1 character vector.
#' @keywords internal
.compile_dash <- function(...) {
  paste(..., sep = "-")
}

#' Paste together collapsing with -
#'
#' @param ... Things to paste.
#' @returns A length-1 character vector.
#' @keywords internal
.collapse_dash <- function(...) {
  paste(..., collapse = "-")
}
