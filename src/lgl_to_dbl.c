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
 * Returns a named list of two vectors of length(x):
 *   $result: double -- NA passes through; TRUE -> 1.0; FALSE -> 0.0
 *   $valid:  logical -- always TRUE (every logical is dbl-ish)
 */
SEXP stbl_lgl_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  lgl_to_dbl_core(x, n, REAL(result));

  SEXP valid = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(valid);
  for (R_xlen_t i = 0; i < n; i++) p[i] = 1;

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SET_VECTOR_ELT(out, 0, result);
  SET_VECTOR_ELT(out, 1, valid);
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_STRING_ELT(names, 0, Rf_mkChar("result"));
  SET_STRING_ELT(names, 1, Rf_mkChar("valid"));
  Rf_setAttrib(out, R_NamesSymbol, names);
  UNPROTECT(4);
  return out;
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
