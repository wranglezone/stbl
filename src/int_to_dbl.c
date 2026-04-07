#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>

/*
 * Core single-pass integer-to-double conversion.
 *
 * All integers are representable as doubles. NA_INTEGER passes through as
 * NA_REAL; all other values are cast exactly.
 */
static void int_to_dbl_core(SEXP x, R_xlen_t n, double* p_result) {
  int* px = INTEGER(x);
  for (R_xlen_t i = 0; i < n; i++) {
    p_result[i] = (px[i] == NA_INTEGER) ? NA_REAL : (double)px[i];
  }
}

/*
 * stbl_int_to_dbl: public API entry point.
 *
 * Returns a double vector of length(x). NA_integer_ passes through as
 * NA_real_; all other values are cast exactly.
 */
SEXP stbl_int_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  int_to_dbl_core(x, n, REAL(result));
  UNPROTECT(1);
  return result;
}

/*
 * stbl_int_are_dblish: public API entry point.
 *
 * All integers are double-ish. Returns a logical vector of length(x) filled
 * with TRUE.
 */
SEXP stbl_int_are_dblish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(result);
  for (R_xlen_t i = 0; i < n; i++) p[i] = 1;
  UNPROTECT(1);
  return result;
}
