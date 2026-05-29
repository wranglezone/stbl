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
 * Returns a named list of two vectors of length(x):
 *   $result: double -- NA_integer_ passes through as NA_real_; all other values cast exactly
 *   $valid:  logical -- always TRUE (every integer is dbl-ish)
 */
SEXP stbl_int_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  int_to_dbl_core(x, n, REAL(result));

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
