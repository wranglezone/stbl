#include <R.h>
#include <Rinternals.h>

/*
 * stbl_lst_to_chr: public API entry point.
 *
 * Fast-path conversion of a flat list to a named list:
 *   $result: character vector of length(x)
 *   $valid:  logical vector -- TRUE for elements that were length-1
 *            character scalars, FALSE otherwise
 *
 * Only character scalars are handled directly; other atomic types (logical,
 * integer, double) would require format() or as.character() which is deferred
 * to R.  Elements that fail produce NA_character_ in $result and FALSE in
 * $valid.
 */
SEXP stbl_lst_to_chr(SEXP x) {
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
