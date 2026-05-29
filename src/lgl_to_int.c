#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>

/*
 * Core single-pass logical-to-integer conversion.
 *
 * NA_LOGICAL passes through as NA_INTEGER; TRUE -> 1L; FALSE -> 0L.
 */
static void lgl_to_int_core(SEXP x, R_xlen_t n, int* p_result) {
  int* px = LOGICAL(x);
  for (R_xlen_t i = 0; i < n; i++) {
    /* NA_LOGICAL == NA_INTEGER in R's internal representation, so this is a
       direct copy; the explicit check is kept for clarity. */
    p_result[i] = (px[i] == NA_LOGICAL) ? NA_INTEGER : px[i];
  }
}

/*
 * stbl_lgl_to_int: public API entry point.
 *
 * Returns a named list of two vectors of length(x):
 *   $result: integer -- NA passes through; TRUE -> 1L; FALSE -> 0L
 *   $valid:  logical -- always TRUE (every logical is int-ish)
 */
SEXP stbl_lgl_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(INTSXP, n));
  lgl_to_int_core(x, n, INTEGER(result));

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
 * stbl_lgl_are_intish: public API entry point.
 *
 * All logicals are integer-ish. Returns a logical vector of length(x) filled
 * with TRUE.
 */
SEXP stbl_lgl_are_intish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(result);
  for (R_xlen_t i = 0; i < n; i++) p[i] = 1;
  UNPROTECT(1);
  return result;
}
