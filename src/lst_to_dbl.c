#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>

/*
 * stbl_lst_to_dbl: public API entry point.
 *
 * Fast-path conversion of a flat list of scalar numeric/logical/integer
 * values to a double vector.  Returns R_NilValue (NULL) if any element is
 * not a length-1 atomic numeric/logical/integer, so the R caller can fall
 * back to the general-purpose R implementation.
 *
 * This avoids the overhead of R's unlist() for the common case of a flat
 * list of scalars.
 */
SEXP stbl_lst_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  double* p = REAL(result);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP elem = VECTOR_ELT(x, i);
    if (XLENGTH(elem) != 1) { UNPROTECT(1); return R_NilValue; }

    switch (TYPEOF(elem)) {
      case REALSXP: {
        p[i] = REAL(elem)[0];
        break;
      }
      case INTSXP: {
        int v = INTEGER(elem)[0];
        p[i] = (v == NA_INTEGER) ? NA_REAL : (double)v;
        break;
      }
      case LGLSXP: {
        int v = LOGICAL(elem)[0];
        p[i] = (v == NA_LOGICAL) ? NA_REAL : (double)v;
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
