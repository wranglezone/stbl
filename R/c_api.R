# Unexported wrappers around the public C routines, used to drive test coverage.

.chr_to_lgl <- function(x) {
  .Call(stbl_chr_to_lgl, x)
}
