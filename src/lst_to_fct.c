#include <R.h>
#include <Rinternals.h>

/*
 * stbl_lst_to_fct: public API entry point.
 *
 * Fast-path conversion of a flat list of scalar character values to a
 * character vector suitable for factor construction.  Returns R_NilValue
 * (NULL) if any element is not a length-1 character scalar, so the R caller
 * can fall back to the general-purpose R implementation.
 *
 * Factor creation (assigning levels, integer codes) must be done on the R
 * side; this function only assembles the character vector of values.
 */
SEXP stbl_lst_to_fct(SEXP x) {
  R_xlen_t n = XLENGTH(x);

  /* Only proceed if every element is a length-1 character */
  for (R_xlen_t i = 0; i < n; i++) {
    SEXP elem = VECTOR_ELT(x, i);
    if (XLENGTH(elem) != 1 || TYPEOF(elem) != STRSXP) {
      return R_NilValue;
    }
  }

  SEXP result = PROTECT(Rf_allocVector(STRSXP, n));
  for (R_xlen_t i = 0; i < n; i++) {
    SET_STRING_ELT(result, i, STRING_ELT(VECTOR_ELT(x, i), 0));
  }
  UNPROTECT(1);
  return result;
}
