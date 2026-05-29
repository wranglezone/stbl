#include "stbl.h"
#include <R_ext/Complex.h>
#include <math.h>

/*
 * stbl_lst_to_int: public API entry point.
 *
 * Converts a flat list to a named list:
 *   $result: integer vector of length(x)
 *   $valid:  logical vector -- TRUE for elements that were successfully
 *            converted, FALSE otherwise
 *
 * Applies the same per-element coercion logic as stbl_y_to_int:
 *   integer   -> direct (always valid)
 *   logical   -> lgl_to_int (always valid)
 *   double    -> dbl_to_int (valid if whole number in R's integer range)
 *   character -> chr_to_int (valid if parseable as a whole number)
 *   complex   -> cpx_to_int (valid if Im == 0 and Re is a whole number)
 *   factor    -> fct_to_int via level string (valid if level is a whole number)
 *   other / length != 1: NA_integer_, valid = FALSE
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

    /* Detect factors before dispatching on TYPEOF, since factors are INTSXP. */
    if (TYPEOF(elem) == INTSXP) {
      SEXP levels = Rf_getAttrib(elem, R_LevelsSymbol);
      if (!Rf_isNull(levels)) {
        int code = INTEGER(elem)[0];
        if (code == NA_INTEGER) {
          p_r[i] = NA_INTEGER;
          p_v[i] = 1;
        } else {
          SEXP lvl = PROTECT(Rf_ScalarString(STRING_ELT(levels, code - 1)));
          int non_number, bad_precision;
          stbl_chr_to_int_core(lvl, 1, &p_r[i], &non_number, &bad_precision);
          p_v[i] = !non_number && !bad_precision;
          UNPROTECT(1);
        }
        continue;
      }
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
      case STRSXP: {
        int non_number, bad_precision;
        stbl_chr_to_int_core(elem, 1, &p_r[i], &non_number, &bad_precision);
        p_v[i] = !non_number && !bad_precision;
        break;
      }
      case CPLXSXP: {
        Rcomplex cpx = COMPLEX(elem)[0];
        if (ISNAN(cpx.r) || ISNAN(cpx.i)) {
          p_r[i] = NA_INTEGER;
          p_v[i] = 1;
        } else if (cpx.i != 0.0) {
          p_r[i] = NA_INTEGER;
          p_v[i] = 0;
        } else {
          double r = cpx.r;
          if (!R_FINITE(r) || r < STBL_INT_MIN || r > STBL_INT_MAX ||
              r != floor(r)) {
            p_r[i] = NA_INTEGER;
            p_v[i] = 0;
          } else {
            p_r[i] = (int)r;
            p_v[i] = 1;
          }
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
