#include <R.h>
#include <Rinternals.h>

/*
 * stbl_lgl_to_chr: public API entry point.
 *
 * Returns a named list of two vectors of length(x):
 *   $result: character -- NA_logical_ passes through as NA_character_;
 *            TRUE -> "TRUE"; FALSE -> "FALSE"
 *   $valid:  logical -- always TRUE (every logical is chr-ish)
 */
SEXP stbl_lgl_to_chr(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_coerceVector(x, STRSXP));

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
 * stbl_lgl_are_chrish: public API entry point.
 *
 * All logicals are chr-ish. Returns a logical vector of length(x) filled
 * with TRUE.
 */
SEXP stbl_lgl_are_chrish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(result);
  for (R_xlen_t i = 0; i < n; i++) p[i] = 1;
  UNPROTECT(1);
  return result;
}
