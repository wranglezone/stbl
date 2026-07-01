# Unexported wrappers around the public C routines, used to drive test coverage.
# Each to_* wrapper returns list(result = <type>, valid = <lgl>) from the C
# callable.

# chr -> * ----

#' Call the C routine to convert a vector to another type
#'
#' @inheritParams .shared-params
#'
#' @returns `.x_to_y()`: A list with two elements: `result`, the converted
#'   vector, and `valid`, a logical vector indicating whether each element was
#'   successfully coerced without losing information. `.x_are_yish()`: A logical
#'   vector indicating whether each element of `x` can be coerced to the target
#'   type. `.check_min_dbl()` and `.check_max_dbl()`: `NULL` if all values pass
#'   the check, otherwise a vector of failing indices.
#' @keywords internal
#' @name c_x_to_y
.chr_to_lgl <- function(x) {
  .Call(stbl_chr_to_lgl, x)
}

#' @rdname c_x_to_y
.chr_to_int <- function(x) {
  .Call(stbl_chr_to_int, x)
}

#' @rdname c_x_to_y
.chr_to_dbl <- function(x) {
  .Call(stbl_chr_to_dbl, x)
}

#' @rdname c_x_to_y
.chr_are_fctish <- function(x, levels = NULL, to_na = character()) {
  .Call(stbl_chr_are_fctish, x, levels, to_na)
}

# dbl -> * ----

#' @rdname c_x_to_y
.dbl_to_int <- function(x) {
  .Call(stbl_dbl_to_int, x)
}

#' @rdname c_x_to_y
.dbl_to_lgl <- function(x) {
  .Call(stbl_dbl_to_lgl, x)
}

#' @rdname c_x_to_y
.dbl_are_lglish <- function(x) {
  .Call(stbl_dbl_are_lglish, x)
}

# int -> * ----

#' @rdname c_x_to_y
.int_to_dbl <- function(x) {
  .Call(stbl_int_to_dbl, x)
}

#' @rdname c_x_to_y
.int_are_dblish <- function(x) {
  .Call(stbl_int_are_dblish, x)
}

# lgl -> * ----

#' @rdname c_x_to_y
.lgl_to_dbl <- function(x) {
  .Call(stbl_lgl_to_dbl, x)
}

#' @rdname c_x_to_y
.lgl_to_int <- function(x) {
  .Call(stbl_lgl_to_int, x)
}

#' @rdname c_x_to_y
.lgl_are_dblish <- function(x) {
  .Call(stbl_lgl_are_dblish, x)
}

#' @rdname c_x_to_y
.lgl_are_intish <- function(x) {
  .Call(stbl_lgl_are_intish, x)
}

# cpx -> * ----

#' @rdname c_x_to_y
.cpx_to_dbl <- function(x) {
  .Call(stbl_cpx_to_dbl, x)
}

#' @rdname c_x_to_y
.cpx_to_int <- function(x) {
  .Call(stbl_cpx_to_int, x)
}

# fct -> * ----

#' @rdname c_x_to_y
.fct_to_dbl <- function(x) {
  .Call(stbl_fct_to_dbl, x)
}

#' @rdname c_x_to_y
.fct_to_int <- function(x) {
  .Call(stbl_fct_to_int, x)
}

#' @rdname c_x_to_y
.fct_to_lgl <- function(x) {
  .Call(stbl_fct_to_lgl, x)
}

#' @rdname c_x_to_y
.fct_are_fctish <- function(x, levels = NULL, to_na = character()) {
  .Call(stbl_fct_are_fctish, x, levels, to_na)
}

# lst -> * ----

#' @rdname c_x_to_y
.lst_to_dbl <- function(x) {
  .Call(stbl_lst_to_dbl, x)
}

#' @rdname c_x_to_y
.lst_to_int <- function(x) {
  .Call(stbl_lst_to_int, x)
}

#' @rdname c_x_to_y
.lst_to_lgl <- function(x) {
  .Call(stbl_lst_to_lgl, x)
}

#' @rdname c_x_to_y
.lst_to_chr <- function(x) {
  .Call(stbl_lst_to_chr, x)
}

#' @rdname c_x_to_y
.lst_to_fct <- function(x) {
  .Call(stbl_lst_to_fct, x)
}

# stbl_to ----

#' @rdname c_x_to_y
.stbl_to <- function(x, to) {
  .Call(stbl_to, x, to)
}

# range checks ----

#' @rdname c_x_to_y
.check_min_dbl <- function(x, min_val) {
  .Call(stbl_check_min_dbl, x, min_val)
}

#' @rdname c_x_to_y
.check_max_dbl <- function(x, max_val) {
  .Call(stbl_check_max_dbl, x, max_val)
}
