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
 * Fast-path conversion of a flat list to a named list:
 *   $result: integer vector of length(x)
 *   $valid:  logical vector -- TRUE for elements that were length-1
 *            integer/logical scalars or whole-number doubles in range,
 *            FALSE otherwise
 *
 * Elements that fail produce NA_integer_ in $result and FALSE in $valid.
 */
SEXP stbl_lst_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_r = INTEGER(result);
  int* p_v = LOGICAL(valid);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP elem = VECTOR_ELT(x, i);
    if (XLENGTH(elem) != 1) {
      p_r[i] = NA_INTEGER;
      p_v[i] = 0;
      continue;
    }

    switch (TYPEOF(elem)) {
      case INTSXP: {
        p_r[i] = INTEGER(elem)[0];
        p_v[i] = 1;
        break;
      }
      case LGLSXP: {
        int v = LOGICAL(elem)[0];
        p_r[i] = (v == NA_LOGICAL) ? NA_INTEGER : v;
        p_v[i] = 1;
        break;
      }
      case REALSXP: {
        double v = REAL(elem)[0];
        if (ISNAN(v)) {
          p_r[i] = NA_INTEGER;
          p_v[i] = 1;
        } else if (!R_FINITE(v) || v < STBL_INT_MIN || v > STBL_INT_MAX ||
                   v != floor(v)) {
          p_r[i] = NA_INTEGER;
          p_v[i] = 0;
        } else {
          p_r[i] = (int)v;
          p_v[i] = 1;
        }
        break;
      }
      default:
        p_r[i] = NA_INTEGER;
        p_v[i] = 0;
        break;
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
