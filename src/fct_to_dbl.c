#include "stbl.h"

/*
 * Factor-to-double conversion using level lookup.
 *
 * A factor stores values as 1-indexed integer codes over a character levels
 * attribute.  By converting each unique level once (instead of materialising
 * the full as.character(x) result), this function is O(nlevels + n) rather
 * than O(n * per-string-conversion).
 *
 * Fills p_result[0..n-1] and p_valid[0..n-1] using the per-element integer
 * codes and pre-converted level values.
 *
 *   code == NA_INTEGER  ->  NA_REAL, valid = 1 (NA elements are stored as
 *                           NA_INTEGER in the factor's integer vector)
 *   code k (1-indexed)  ->  level_result[k-1], valid = level_valid[k-1]
 */
static void fct_to_dbl_core(SEXP x, R_xlen_t n,
                              double* p_result, int* p_valid) {
  SEXP levels = Rf_getAttrib(x, R_LevelsSymbol);
  R_xlen_t nlev = Rf_isNull(levels) ? 0 : XLENGTH(levels);

  /* Convert all levels once */
  double* level_result = (double*) R_alloc(nlev, sizeof(double));
  int*    level_valid  = (int*)    R_alloc(nlev, sizeof(int));
  if (nlev > 0) {
    stbl_chr_to_dbl_core(levels, nlev, level_result, level_valid);
  }

  int* codes = INTEGER(x);
  for (R_xlen_t i = 0; i < n; i++) {
    int code = codes[i];
    if (code == NA_INTEGER) {
      p_result[i] = NA_REAL;
      p_valid[i]  = 1;
    } else {
      R_xlen_t idx = (R_xlen_t)(code - 1);
      p_result[i] = level_result[idx];
      p_valid[i]  = level_valid[idx];
    }
  }
}

/*
 * ffi_fct_to_dbl: internal FFI entry point used by stbl itself.
 *
 * Returns a named list of two vectors of length(x):
 *   $result: double — the converted values (NA_real_ where conversion failed)
 *   $valid:  logical — TRUE for elements that converted successfully
 */
SEXP ffi_fct_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  fct_to_dbl_core(x, n, REAL(result), LOGICAL(valid));

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
 * stbl_fct_to_dbl: public API entry point.
 *
 * Returns a double vector of length(x) (NA_real_ where conversion failed).
 */
SEXP stbl_fct_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  fct_to_dbl_core(x, n, REAL(result), LOGICAL(valid));
  UNPROTECT(2);
  return result;
}

/*
 * stbl_fct_are_dblish: public API entry point.
 *
 * Returns a logical vector of length(x) that is TRUE for elements whose
 * level string can be coerced to double (and for NA elements).
 */
SEXP stbl_fct_are_dblish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  fct_to_dbl_core(x, n, REAL(result), LOGICAL(valid));
  UNPROTECT(2);
  return valid;
}
