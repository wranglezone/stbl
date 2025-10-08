#' Signal an error with standards applied
#'
#' A wrapper around [cli::cli_abort()] to throw classed errors, with an
#' opinionated framework of error classes.
#'
#' @param message (`character`) The message for the new error. Messages will be
#'   formatted with [cli::cli_bullets()].
#' @param subclass (`character`) Class(es) to assign to the error. Will be
#'   prefixed by "\{package\}-error-".
#' @param ... Additional parameters passed to [cli::cli_abort()] and on to
#'   [rlang::abort()].
#' @inheritParams .shared-params
#' @examples
#' try(pkg_abort("stbl", "This is a test error", "test_subclass"))
#' tryCatch(
#'   pkg_abort("stbl", "This is a test error", "test_subclass"),
#'   `stbl-error` = function(e) {
#'     "Caught a generic stbl error."
#'   }
#' )
#' tryCatch(
#'   pkg_abort("stbl", "This is a test error", "test_subclass"),
#'   `stbl-error-test_subclass` = function(e) {
#'     "Caught a specific subclass of stbl error."
#'   }
#' )
#'
#' @export
pkg_abort <- function(
  package,
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
) {
  cli::cli_abort(
    message,
    class = compile_pkg_error_classes(package, subclass),
    call = call,
    .envir = message_env,
    parent = parent,
    ...
  )
}

#' Compile a condition class chain
#'
#' Implements an opinionated framework in which condition classes are composed
#' by joining pieces of the class with "-", and always include a base class
#' formed by combining the namme of the package and the word "condition".
#'
#' @param ... `(character)` Components of the class name.
#' @inheritParams .shared-params
#'
#' @returns A character vector.
#' @examples
#' compile_pkg_condition_classes("stbl")
#' compile_pkg_condition_classes("stbl", "error")
#' compile_pkg_condition_classes("stbl", "warning")
#'
#' @export
compile_pkg_condition_classes <- function(package, ...) {
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

#' Compile an error class chain
#'
#' Compile a set of classes for a package error, from most-specific to least.
#'
#' @param ... `(character)` Components of the class name, from least-specific to
#'   most.
#' @inheritParams .shared-params
#'
#' @returns A character vector of classes (see examples).
#' @examples
#' compile_pkg_error_classes("stbl")
#' compile_pkg_error_classes("stbl", "coerce", "character", "scalar")
#'
#' @export
compile_pkg_error_classes <- function(package, ...) {
  compile_pkg_condition_classes(package, "error", ...)
}
