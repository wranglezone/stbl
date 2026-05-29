#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>

/*
 * stbl_lst_to_dbl: public API entry point.
 *
 * Fast-path conversion of a flat list to a named list:
 *   $result: double vector of length(x)
 *   $valid:  logical vector -- TRUE for elements that were length-1
 *            atomic numeric/logical/integer scalars, FALSE otherwise
 *
 * Elements that fail (wrong type or length != 1) produce NA_REAL in $result
 * and FALSE in $valid, letting the C consumer detect failures without a
 * second-pass are_*ish call.
 */
SEXP stbl_lst_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  double* p_r = REAL(result);
  int*    p_v = LOGICAL(valid);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP elem = VECTOR_ELT(x, i);
    if (XLENGTH(elem) != 1) {
      p_r[i] = NA_REAL;
      p_v[i] = 0;
      continue;
    }

    switch (TYPEOF(elem)) {
      case REALSXP: {
        p_r[i] = REAL(elem)[0];
        p_v[i] = 1;
        break;
      }
      case INTSXP: {
        int v = INTEGER(elem)[0];
        p_r[i] = (v == NA_INTEGER) ? NA_REAL : (double)v;
        p_v[i] = 1;
        break;
      }
      case LGLSXP: {
        int v = LOGICAL(elem)[0];
        p_r[i] = (v == NA_LOGICAL) ? NA_REAL : (double)v;
        p_v[i] = 1;
        break;
      }
      default:
        p_r[i] = NA_REAL;
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
