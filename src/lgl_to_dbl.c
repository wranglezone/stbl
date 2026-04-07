#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>

/*
 * Core single-pass logical-to-double conversion.
 *
 * NA_LOGICAL passes through as NA_REAL; TRUE -> 1.0; FALSE -> 0.0.
 */
static void lgl_to_dbl_core(SEXP x, R_xlen_t n, double* p_result) {
  int* px = LOGICAL(x);
  for (R_xlen_t i = 0; i < n; i++) {
    p_result[i] = (px[i] == NA_LOGICAL) ? NA_REAL : (double)px[i];
  }
}

/*
 * stbl_lgl_to_dbl: public API entry point.
 *
 * Returns a double vector of length(x). NA passes through; TRUE -> 1.0;
 * FALSE -> 0.0.
 */
SEXP stbl_lgl_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  lgl_to_dbl_core(x, n, REAL(result));
  UNPROTECT(1);
  return result;
}

/*
 * stbl_lgl_are_dblish: public API entry point.
 *
 * All logicals are double-ish. Returns a logical vector of length(x) filled
 * with TRUE.
 */
SEXP stbl_lgl_are_dblish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(result);
  for (R_xlen_t i = 0; i < n; i++) p[i] = 1;
  UNPROTECT(1);
  return result;
}
