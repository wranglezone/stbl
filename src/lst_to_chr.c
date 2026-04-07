#include <R.h>
#include <Rinternals.h>

/*
 * stbl_lst_to_chr: public API entry point.
 *
 * Fast-path conversion of a flat list of scalar character/logical/integer/
 * double values to a character vector.  Returns R_NilValue (NULL) if any
 * element is not a length-1 character scalar, so the R caller can fall back
 * to the general-purpose R implementation.
 *
 * Only character scalars are handled directly; other atomic types would
 * require format() or as.character() which is deferred to R.
 */
SEXP stbl_lst_to_chr(SEXP x) {
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
