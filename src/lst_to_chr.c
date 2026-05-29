#include <R.h>
#include <Rinternals.h>

/*
 * stbl_lst_to_chr: public API entry point.
 *
 * Converts a list to a named list:
 *   $result: character vector
 *   $valid:  logical vector -- TRUE for elements that were successfully
 *            converted, FALSE otherwise
 *
 * Two input shapes are accepted:
 *
 *   1. A flat list of scalars (any length).  Each element must be a
 *      length-1 character scalar; non-character or multi-element elements
 *      produce NA_character_ / valid = FALSE.
 *
 *   2. A one-element list whose single element is a character vector of
 *      any length.  The vector is passed through directly with all
 *      valid = TRUE.
 *
 * Only character vectors pass in both paths; other atomic types (logical,
 * integer, double) would require format() or as.character() which is
 * deferred to R.
 */

/* Build the standard list(result, valid) output SEXP. Caller must have
 * already PROTECTed result and valid. */
static SEXP lst_to_chr_build_out(SEXP result, SEXP valid) {
  SEXP out   = PROTECT(Rf_allocVector(VECSXP, 2));
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_VECTOR_ELT(out, 0, result);
  SET_VECTOR_ELT(out, 1, valid);
  SET_STRING_ELT(names, 0, Rf_mkChar("result"));
  SET_STRING_ELT(names, 1, Rf_mkChar("valid"));
  Rf_setAttrib(out, R_NamesSymbol, names);
  UNPROTECT(2);
  return out;
}

SEXP stbl_lst_to_chr(SEXP x) {
  R_xlen_t n = XLENGTH(x);

  /* Single-vector unpack: one-element list whose single element is a
   * character vector of length != 1.  Pass strings through; all valid. */
  if (n == 1) {
    SEXP elem = VECTOR_ELT(x, 0);
    R_xlen_t m = XLENGTH(elem);
    if (m != 1 && TYPEOF(elem) == STRSXP) {
      SEXP result = PROTECT(elem);
      SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, m));
      int* p_v = LOGICAL(valid);
      for (R_xlen_t j = 0; j < m; j++) p_v[j] = 1;
      SEXP out = lst_to_chr_build_out(result, valid);
      UNPROTECT(2);
      return out;
    }
  }

  /* Flat list of scalars: existing per-element logic. */
  SEXP result = PROTECT(Rf_allocVector(STRSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_v = LOGICAL(valid);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP elem = VECTOR_ELT(x, i);
    if (XLENGTH(elem) != 1 || TYPEOF(elem) != STRSXP) {
      SET_STRING_ELT(result, i, NA_STRING);
      p_v[i] = 0;
    } else {
      SET_STRING_ELT(result, i, STRING_ELT(elem, 0));
      p_v[i] = 1;
    }
  }

  SEXP out = lst_to_chr_build_out(result, valid);
  UNPROTECT(2);
  return out;
}
