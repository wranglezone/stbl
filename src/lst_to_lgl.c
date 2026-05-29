#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>

/*
 * stbl_lst_to_lgl: public API entry point.
 *
 * Fast-path conversion of a flat list to a named list:
 *   $result: logical vector of length(x)
 *   $valid:  logical vector -- TRUE for elements that were length-1
 *            logical/integer/double scalars, FALSE otherwise
 *
 * Elements that fail produce NA in $result and FALSE in $valid.
 */
SEXP stbl_lst_to_lgl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_r = LOGICAL(result);
  int* p_v = LOGICAL(valid);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP elem = VECTOR_ELT(x, i);
    if (XLENGTH(elem) != 1) {
      p_r[i] = NA_LOGICAL;
      p_v[i] = 0;
      continue;
    }

    switch (TYPEOF(elem)) {
      case LGLSXP: {
        p_r[i] = LOGICAL(elem)[0];
        p_v[i] = 1;
        break;
      }
      case INTSXP: {
        int v = INTEGER(elem)[0];
        p_r[i] = (v == NA_INTEGER) ? NA_LOGICAL : (v != 0 ? 1 : 0);
        p_v[i] = 1;
        break;
      }
      case REALSXP: {
        double v = REAL(elem)[0];
        if (ISNAN(v)) {
          p_r[i] = NA_LOGICAL;
        } else {
          p_r[i] = (v != 0.0) ? 1 : 0;
        }
        p_v[i] = 1;
        break;
      }
      default:
        p_r[i] = NA_LOGICAL;
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
