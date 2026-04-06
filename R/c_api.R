# Unexported wrappers around the public C routines, used to drive test coverage.

.chr_to_lgl <- function(x) {
  .Call(stbl_chr_to_lgl, x)
}

.chr_to_int <- function(x) {
  .Call(stbl_chr_to_int, x)
}

.chr_to_dbl <- function(x) {
  .Call(stbl_chr_to_dbl, x)
}
