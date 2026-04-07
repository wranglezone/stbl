#include "stbl.h"

/*
 * Factor-to-logical conversion using level lookup.
 *
 * Converts each unique level string once and maps back via integer codes,
 * avoiding materialisation of the full as.character(x) vector.
 *
 *   code == NA_INTEGER  ->  NA_LOGICAL, valid = 1
 *   code k (1-indexed)  ->  level_result[k-1], level_valid[k-1]
 */
static void fct_to_lgl_core(SEXP x, R_xlen_t n,
                              int* p_result, int* p_valid) {
  SEXP levels = Rf_getAttrib(x, R_LevelsSymbol);
  R_xlen_t nlev = Rf_isNull(levels) ? 0 : XLENGTH(levels);

  int* level_result = (int*) R_alloc(nlev, sizeof(int));
  int* level_valid  = (int*) R_alloc(nlev, sizeof(int));
  if (nlev > 0) {
    stbl_chr_to_lgl_core(levels, nlev, level_result, level_valid);
  }

  int* codes = INTEGER(x);
  for (R_xlen_t i = 0; i < n; i++) {
    int code = codes[i];
    if (code == NA_INTEGER) {
      p_result[i] = NA_LOGICAL;
      p_valid[i]  = 1;
    } else {
      R_xlen_t idx = (R_xlen_t)(code - 1);
      p_result[i] = level_result[idx];
      p_valid[i]  = level_valid[idx];
    }
  }
}

/*
 * ffi_fct_to_lgl: internal FFI entry point used by stbl itself.
 *
 * Returns a named list of two vectors of length(x):
 *   $result: logical — the converted values (NA where conversion failed)
 *   $valid:  logical — TRUE for elements that converted successfully
 */
SEXP ffi_fct_to_lgl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  fct_to_lgl_core(x, n, LOGICAL(result), LOGICAL(valid));

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
 * stbl_fct_to_lgl: public API entry point.
 *
 * Returns a logical vector of length(x) (NA where conversion failed).
 */
SEXP stbl_fct_to_lgl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  fct_to_lgl_core(x, n, LOGICAL(result), LOGICAL(valid));
  UNPROTECT(2);
  return result;
}

/*
 * stbl_fct_are_lglish: public API entry point.
 *
 * Returns a logical vector of length(x) that is TRUE for elements whose
 * level string can be coerced to logical (and for NA elements).
 */
SEXP stbl_fct_are_lglish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  fct_to_lgl_core(x, n, LOGICAL(result), LOGICAL(valid));
  UNPROTECT(2);
  return valid;
}
