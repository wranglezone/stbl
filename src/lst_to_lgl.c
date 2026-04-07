#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>

/*
 * stbl_lst_to_lgl: public API entry point.
 *
 * Fast-path conversion of a flat list of scalar logical/integer/double values
 * to a logical vector.  Returns R_NilValue (NULL) if any element is not a
 * length-1 logical, integer, or double scalar, so the R caller can fall back
 * to the general-purpose R implementation.
 */
SEXP stbl_lst_to_lgl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(result);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP elem = VECTOR_ELT(x, i);
    if (XLENGTH(elem) != 1) { UNPROTECT(1); return R_NilValue; }

    switch (TYPEOF(elem)) {
      case LGLSXP: {
        p[i] = LOGICAL(elem)[0];
        break;
      }
      case INTSXP: {
        int v = INTEGER(elem)[0];
        p[i] = (v == NA_INTEGER) ? NA_LOGICAL : (v != 0 ? 1 : 0);
        break;
      }
      case REALSXP: {
        double v = REAL(elem)[0];
        if (ISNAN(v)) {
          p[i] = NA_LOGICAL;
        } else {
          p[i] = (v != 0.0) ? 1 : 0;
        }
        break;
      }
      default:
        UNPROTECT(1);
        return R_NilValue;
    }
  }

  UNPROTECT(1);
  return result;
}
