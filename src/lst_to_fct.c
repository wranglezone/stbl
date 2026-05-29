#include <R.h>
#include <Rinternals.h>

/*
 * stbl_lst_to_fct: public API entry point.
 *
 * Fast-path conversion of a flat list to a named list:
 *   $result: character vector of length(x) suitable for factor construction
 *   $valid:  logical vector -- TRUE for elements that were length-1
 *            character scalars, FALSE otherwise
 *
 * Factor creation (assigning levels, integer codes) must be done on the R
 * side; this function only assembles the character vector of values.
 * Elements that fail produce NA_character_ in $result and FALSE in $valid.
 */
SEXP stbl_lst_to_fct(SEXP x) {
  R_xlen_t n = XLENGTH(x);
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
