#include "stbl.h"

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
 *      length-1 atomic value coercible to character (or a singly-nested
 *      list that unwraps to one); elements that are not produce
 *      NA_character_ / valid = FALSE.
 *
 *   2. A one-element list whose single element is a character vector of
 *      any length.  The vector is passed through directly with all
 *      valid = TRUE.
 *
 * Coercion rules (per element, same as to_chr for non-list types):
 *   character -> direct
 *   logical   -> "TRUE" / "FALSE" / NA_character_
 *   integer   -> decimal string representation
 *   double    -> R-formatted string representation
 *   complex   -> R-formatted string representation
 *   factor    -> level label
 *   nested list (VECSXP length 1) -> unwrap and apply above rules
 *   other / multi-element: NA_character_, valid = FALSE
 */

/* Return the CHARSXP for a length-1 atomic element.
 * Sets *valid = 1 for coercible types (including NA), 0 otherwise. */
static SEXP lst_to_chr_elem_to_charsxp(SEXP elem, int *valid) {
  /* Factor: resolve integer code to level label */
  if (Rf_isFactor(elem)) {
    int code = INTEGER(elem)[0];
    if (code == NA_INTEGER) { *valid = 1; return NA_STRING; }
    SEXP levels = Rf_getAttrib(elem, R_LevelsSymbol);
    *valid = 1;
    return STRING_ELT(levels, code - 1);
  }
  switch (TYPEOF(elem)) {
    case STRSXP:
    case INTSXP:
    case REALSXP:
    case LGLSXP:
    case CPLXSXP:
      *valid = 1;
      /* Rf_asChar handles NA, formatting for all atomic types */
      return Rf_asChar(elem);
    default:
      *valid = 0;
      return NA_STRING;
  }
}

SEXP stbl_lst_to_chr(SEXP x) {
  R_xlen_t n = XLENGTH(x);

  /* Single-vector unpack: one-element list whose single element is a
   * character vector of length != 1.  Pass strings through; all valid. */
  if (n == 1) {
    SEXP elem = VECTOR_ELT(x, 0);
    R_xlen_t m;
    if (TYPEOF(elem) == STRSXP && (m = XLENGTH(elem)) != 1) {
      SEXP result = PROTECT(elem);
      SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, m));
      int* p_v = LOGICAL(valid);
      for (R_xlen_t j = 0; j < m; j++) p_v[j] = 1;
      SEXP out = lst_build_out(result, valid);
      UNPROTECT(2);
      return out;
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
    int valid_elem;
    SET_STRING_ELT(result, i, lst_to_chr_elem_to_charsxp(elem, &valid_elem));
    p_v[i] = valid_elem;
  }

  SEXP out = lst_build_out(result, valid);
  UNPROTECT(2);
  return out;
}
