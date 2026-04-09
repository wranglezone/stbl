# Unexported wrappers around the public C routines, used to drive test coverage.

# chr -> * ----

.chr_to_lgl <- function(x) {
  .Call(stbl_chr_to_lgl, x)
}

.chr_to_int <- function(x) {
  .Call(stbl_chr_to_int, x)
}

.chr_to_dbl <- function(x) {
  .Call(stbl_chr_to_dbl, x)
}

.chr_are_fctish <- function(x, levels = NULL, to_na = character()) {
  .Call(stbl_chr_are_fctish, x, levels, to_na)
}

# dbl -> * ----

.dbl_to_int <- function(x) {
  .Call(stbl_dbl_to_int, x)
}

.dbl_to_lgl <- function(x) {
  .Call(stbl_dbl_to_lgl, x)
}

# int -> * ----

.int_to_dbl <- function(x) {
  .Call(stbl_int_to_dbl, x)
}

# lgl -> * ----

.lgl_to_dbl <- function(x) {
  .Call(stbl_lgl_to_dbl, x)
}

.lgl_to_int <- function(x) {
  .Call(stbl_lgl_to_int, x)
}

# cpx -> * ----

.cpx_to_dbl <- function(x) {
  .Call(stbl_cpx_to_dbl, x)
}

.cpx_to_int <- function(x) {
  .Call(stbl_cpx_to_int, x)
}

# fct -> * ----

.fct_to_dbl <- function(x) {
  .Call(stbl_fct_to_dbl, x)
}

.fct_to_int <- function(x) {
  .Call(stbl_fct_to_int, x)
}

.fct_to_lgl <- function(x) {
  .Call(stbl_fct_to_lgl, x)
}

.fct_are_fctish <- function(x, levels = NULL, to_na = character()) {
  .Call(stbl_fct_are_fctish, x, levels, to_na)
}

# lst -> * ----

.lst_to_dbl <- function(x) {
  .Call(stbl_lst_to_dbl, x)
}

.lst_to_int <- function(x) {
  .Call(stbl_lst_to_int, x)
}

.lst_to_lgl <- function(x) {
  .Call(stbl_lst_to_lgl, x)
}

.lst_to_chr <- function(x) {
  .Call(stbl_lst_to_chr, x)
}

.lst_to_fct <- function(x) {
  .Call(stbl_lst_to_fct, x)
}

# range checks ----

.check_min_dbl <- function(x, min_val) {
  .Call(stbl_check_min_dbl, x, min_val)
}

.check_max_dbl <- function(x, max_val) {
  .Call(stbl_check_max_dbl, x, max_val)
}
