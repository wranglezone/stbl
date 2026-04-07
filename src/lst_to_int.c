#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>
#include <math.h>

/* Valid R integer range */
#define STBL_INT_MAX  2147483647.0
#define STBL_INT_MIN -2147483647.0

/*
 * stbl_lst_to_int: public API entry point.
 *
 * Fast-path conversion of a flat list of scalar integer/logical values to an
 * integer vector.  Returns R_NilValue (NULL) if any element is not a length-1
 * integer or logical scalar, so the R caller can fall back to R's
 * general-purpose implementation.
 *
 * Double elements that are whole numbers in R's integer range are also
 * accepted.  Elements outside the representable range or with a fractional
 * part cause a NULL return, deferring to the R code for proper error
 * messages.
 */
SEXP stbl_lst_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(INTSXP, n));
  int* p = INTEGER(result);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP elem = VECTOR_ELT(x, i);
    if (XLENGTH(elem) != 1) { UNPROTECT(1); return R_NilValue; }

    switch (TYPEOF(elem)) {
      case INTSXP: {
        p[i] = INTEGER(elem)[0];
        break;
      }
      case LGLSXP: {
        int v = LOGICAL(elem)[0];
        p[i] = (v == NA_LOGICAL) ? NA_INTEGER : v;
        break;
      }
      case REALSXP: {
        double v = REAL(elem)[0];
        if (ISNAN(v)) {
          p[i] = NA_INTEGER;
        } else if (!R_FINITE(v) || v < STBL_INT_MIN || v > STBL_INT_MAX ||
                   v != floor(v)) {
          UNPROTECT(1);
          return R_NilValue;
        } else {
          p[i] = (int)v;
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
