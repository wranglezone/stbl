#include "stbl.h"

/*
 * Factor-to-integer conversion using level lookup.
 *
 * Converts each unique level string once and maps back via integer codes,
 * avoiding materialisation of the full as.character(x) vector.
 *
 *   code == NA_INTEGER  ->  NA_INTEGER, non_number = 0, bad_precision = 0
 *   code k (1-indexed)  ->  level_result[k-1], propagating flags
 */
static void fct_to_int_core(SEXP x, R_xlen_t n,
                              int* p_result,
                              int* p_non_number,
                              int* p_bad_precision) {
  SEXP levels = Rf_getAttrib(x, R_LevelsSymbol);
  R_xlen_t nlev = Rf_isNull(levels) ? 0 : XLENGTH(levels);

  int* level_result        = (int*) R_alloc(nlev, sizeof(int));
  int* level_non_number    = (int*) R_alloc(nlev, sizeof(int));
  int* level_bad_precision = (int*) R_alloc(nlev, sizeof(int));
  if (nlev > 0) {
    stbl_chr_to_int_core(levels, nlev, level_result, level_non_number,
                         level_bad_precision);
  }

  int* codes = INTEGER(x);
  for (R_xlen_t i = 0; i < n; i++) {
    int code = codes[i];
    if (code == NA_INTEGER) {
      p_result[i]        = NA_INTEGER;
      p_non_number[i]    = 0;
      p_bad_precision[i] = 0;
    } else {
      R_xlen_t idx = (R_xlen_t)(code - 1);
      p_result[i]        = level_result[idx];
      p_non_number[i]    = level_non_number[idx];
      p_bad_precision[i] = level_bad_precision[idx];
    }
  }
}

/*
 * ffi_fct_to_int: internal FFI entry point used by stbl itself.
 *
 * Returns a named list of three vectors of length(x):
 *   $result:        integer — converted values (NA_integer_ where failed)
 *   $non_number:    logical — TRUE for level strings not parseable as numbers
 *   $bad_precision: logical — TRUE for numeric levels not representable as int
 */
SEXP ffi_fct_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP non_number    = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  fct_to_int_core(x, n, INTEGER(result), LOGICAL(non_number),
                  LOGICAL(bad_precision));

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 3));
  SET_VECTOR_ELT(out, 0, result);
  SET_VECTOR_ELT(out, 1, non_number);
  SET_VECTOR_ELT(out, 2, bad_precision);
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 3));
  SET_STRING_ELT(names, 0, Rf_mkChar("result"));
  SET_STRING_ELT(names, 1, Rf_mkChar("non_number"));
  SET_STRING_ELT(names, 2, Rf_mkChar("bad_precision"));
  Rf_setAttrib(out, R_NamesSymbol, names);
  UNPROTECT(5);
  return out;
}

/*
 * stbl_fct_to_int: public API entry point.
 *
 * Returns an integer vector of length(x) (NA_integer_ where failed).
 */
SEXP stbl_fct_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP non_number    = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  fct_to_int_core(x, n, INTEGER(result), LOGICAL(non_number),
                  LOGICAL(bad_precision));
  UNPROTECT(3);
  return result;
}

/*
 * stbl_fct_are_intish: public API entry point.
 *
 * Returns a logical vector of length(x) that is TRUE for elements whose
 * level string represents a whole number in R's integer range (and for NA).
 */
SEXP stbl_fct_are_intish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP non_number    = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  fct_to_int_core(x, n, INTEGER(result), LOGICAL(non_number),
                  LOGICAL(bad_precision));

  SEXP valid = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_non = LOGICAL(non_number);
  int* p_bad = LOGICAL(bad_precision);
  int* p_val = LOGICAL(valid);
  for (R_xlen_t i = 0; i < n; i++) {
    p_val[i] = !p_non[i] && !p_bad[i];
  }
  UNPROTECT(4);
  return valid;
}
