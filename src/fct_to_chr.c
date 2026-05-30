#include <R.h>
#include <Rinternals.h>

/*
 * stbl_fct_to_chr: public API entry point.
 *
 * Returns a named list of two vectors of length(x):
 *   $result: character -- each element is the label string of the
 *            corresponding factor level; NA code passes through as
 *            NA_character_; out-of-range codes produce NA_character_
 *            with valid = FALSE
 *   $valid:  logical -- FALSE only for out-of-range codes; TRUE otherwise
 */
SEXP stbl_fct_to_chr(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP levels = Rf_getAttrib(x, R_LevelsSymbol);
  R_xlen_t nlev = Rf_isNull(levels) ? 0 : XLENGTH(levels);
  int* codes = INTEGER(x);

  SEXP result = PROTECT(Rf_allocVector(STRSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_valid = LOGICAL(valid);

  for (R_xlen_t i = 0; i < n; i++) {
    int code = codes[i];
    if (code == NA_INTEGER) {
      SET_STRING_ELT(result, i, NA_STRING);
      p_valid[i] = 1;
    } else if (code >= 1 && code <= (int)nlev) {
      SET_STRING_ELT(result, i, STRING_ELT(levels, code - 1));
      p_valid[i] = 1;
    } else {
      /* Malformed factor: code is out of the valid range. */
      SET_STRING_ELT(result, i, NA_STRING);
      p_valid[i] = 0;
    }
  }

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
 * stbl_fct_are_chrish: public API entry point.
 *
 * All factor values with in-range codes are chr-ish. Returns a logical
 * vector of length(x) that is TRUE for valid codes (including NA) and
 * FALSE for out-of-range codes.
 */
SEXP stbl_fct_are_chrish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP levels = Rf_getAttrib(x, R_LevelsSymbol);
  R_xlen_t nlev = Rf_isNull(levels) ? 0 : XLENGTH(levels);
  int* codes = INTEGER(x);

  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(result);
  for (R_xlen_t i = 0; i < n; i++) {
    int code = codes[i];
    p[i] = (code == NA_INTEGER || (code >= 1 && code <= (int)nlev)) ? 1 : 0;
  }
  UNPROTECT(1);
  return result;
}
