#include "stbl.h"

/*
 * stbl_lst_to_fct: public API entry point.
 *
 * Converts a list to a named list:
 *   $result: character vector of values suitable for factor construction
 *   $valid:  logical vector -- TRUE for elements that were successfully
 *            converted, FALSE otherwise
 *
 * Two input shapes are accepted:
 *
 *   1. A flat list of scalars (any length).  Each element must be a
 *      length-1 character scalar or length-1 factor (or a singly-nested
 *      list that unwraps to one); other types produce
 *      NA_character_ / valid = FALSE.
 *
 *   2. A one-element list whose single element is either:
 *      - a character vector of any length (strings passed through as-is),
 *      - a factor of any length (level labels extracted).
 *      All elements produce valid = TRUE.
 *
 * Factor creation (assigning levels, integer codes) must be done on the R
 * side; this function only assembles the character vector of labels.
 */

SEXP stbl_lst_to_fct(SEXP x) {
  R_xlen_t n = XLENGTH(x);

  /* Single-vector unpack: one-element list whose element is a character
   * vector or factor of length != 1. */
  if (n == 1) {
    SEXP elem = VECTOR_ELT(x, 0);
    R_xlen_t m = Rf_isVectorAtomic(elem) ? XLENGTH(elem) : 0;
    if (m != 1) {
      if (TYPEOF(elem) == STRSXP) {
        /* Character vector: pass strings through, all valid. */
        SEXP result = PROTECT(elem);
        SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, m));
        int* p_v = LOGICAL(valid);
        for (R_xlen_t j = 0; j < m; j++) p_v[j] = 1;
        SEXP out = lst_build_out(result, valid);
        UNPROTECT(2);
        return out;
      }
      if (Rf_isFactor(elem)) {
        /* Factor: extract character labels, all valid. */
        SEXP result = PROTECT(Rf_allocVector(STRSXP, m));
        SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, m));
        SEXP levels = Rf_getAttrib(elem, R_LevelsSymbol);
        int* codes  = INTEGER(elem);
        int* p_v    = LOGICAL(valid);
        for (R_xlen_t j = 0; j < m; j++) {
          SET_STRING_ELT(result, j,
            codes[j] == NA_INTEGER ? NA_STRING : STRING_ELT(levels, codes[j] - 1));
          p_v[j] = 1;
        }
        SEXP out = lst_build_out(result, valid);
        UNPROTECT(2);
        return out;
      }
    }
  }

  /* Flat list of scalars: per-element logic with VECSXP unwrapping. */
  SEXP result = PROTECT(Rf_allocVector(STRSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_v = LOGICAL(valid);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP elem = lst_unwrap_elem(VECTOR_ELT(x, i));
    if (elem == R_NilValue || !Rf_isVectorAtomic(elem) || XLENGTH(elem) != 1) {
      SET_STRING_ELT(result, i, NA_STRING);
      p_v[i] = 0;
      continue;
    }
    if (Rf_isFactor(elem)) {
      /* Length-1 factor: resolve the integer code to its character label. */
      int code = INTEGER(elem)[0];
      if (code == NA_INTEGER) {
        SET_STRING_ELT(result, i, NA_STRING);
      } else {
        SEXP levels = Rf_getAttrib(elem, R_LevelsSymbol);
        SET_STRING_ELT(result, i, STRING_ELT(levels, code - 1));
      }
      p_v[i] = 1;
    } else if (TYPEOF(elem) != STRSXP) {
      SET_STRING_ELT(result, i, NA_STRING);
      p_v[i] = 0;
    } else {
      SET_STRING_ELT(result, i, STRING_ELT(elem, 0));
      p_v[i] = 1;
    }
  }

  SEXP out = lst_build_out(result, valid);
  UNPROTECT(2);
  return out;
}
