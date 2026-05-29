#include "stbl.h"
#include <R_ext/Complex.h>

/*
 * stbl_lst_to_dbl: public API entry point.
 *
 * Converts a flat list to a named list:
 *   $result: double vector of length(x)
 *   $valid:  logical vector -- TRUE for elements that were successfully
 *            converted, FALSE otherwise
 *
 * Applies the same per-element coercion logic as stbl_y_to_dbl:
 *   double   -> direct (always valid)
 *   integer  -> int_to_dbl (always valid)
 *   logical  -> lgl_to_dbl (always valid)
 *   character -> chr_to_dbl (valid if parseable as a number)
 *   complex  -> cpx_to_dbl (valid if Im == 0 or NA)
 *   factor   -> fct_to_dbl via level string (valid if level is numeric)
 *   other / length != 1: NA_real_, valid = FALSE
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

    /* Detect factors before dispatching on TYPEOF, since factors are INTSXP. */
    if (TYPEOF(elem) == INTSXP) {
      SEXP levels = Rf_getAttrib(elem, R_LevelsSymbol);
      if (!Rf_isNull(levels)) {
        int code = INTEGER(elem)[0];
        if (code == NA_INTEGER) {
          p_r[i] = NA_REAL;
          p_v[i] = 1;
        } else {
          SEXP lvl = PROTECT(Rf_ScalarString(STRING_ELT(levels, code - 1)));
          stbl_chr_to_dbl_core(lvl, 1, &p_r[i], &p_v[i]);
          UNPROTECT(1);
        }
        continue;
      }
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
      case STRSXP: {
        stbl_chr_to_dbl_core(elem, 1, &p_r[i], &p_v[i]);
        break;
      }
      case CPLXSXP: {
        Rcomplex cpx = COMPLEX(elem)[0];
        if (ISNAN(cpx.r) || ISNAN(cpx.i)) {
          p_r[i] = NA_REAL;
          p_v[i] = 1;
        } else if (cpx.i != 0.0) {
          p_r[i] = cpx.r;
          p_v[i] = 0;
        } else {
          p_r[i] = cpx.r;
          p_v[i] = 1;
        }
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
