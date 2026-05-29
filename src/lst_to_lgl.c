#include "stbl.h"

/*
 * stbl_lst_to_lgl: public API entry point.
 *
 * Converts a flat list to a named list:
 *   $result: logical vector of length(x)
 *   $valid:  logical vector -- TRUE for elements that were successfully
 *            converted, FALSE otherwise
 *
 * Applies the same per-element coercion logic as stbl_y_to_lgl:
 *   logical   -> direct (always valid)
 *   integer   -> dbl_to_lgl integer path (always valid)
 *   double    -> dbl_to_lgl (always valid)
 *   character -> chr_to_lgl (valid if TRUE/FALSE/T/F/numeric string)
 *   factor    -> fct_to_lgl via level string (valid if level is lgl-ish)
 *   other / length != 1: NA, valid = FALSE
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

    /* Detect factors before dispatching on TYPEOF, since factors are INTSXP. */
    if (TYPEOF(elem) == INTSXP) {
      SEXP levels = Rf_getAttrib(elem, R_LevelsSymbol);
      if (!Rf_isNull(levels)) {
        int code = INTEGER(elem)[0];
        if (code == NA_INTEGER) {
          p_r[i] = NA_LOGICAL;
          p_v[i] = 1;
        } else {
          SEXP lvl = PROTECT(Rf_ScalarString(STRING_ELT(levels, code - 1)));
          stbl_chr_to_lgl_core(lvl, 1, &p_r[i], &p_v[i]);
          UNPROTECT(1);
        }
        continue;
      }
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
        p_r[i] = ISNAN(v) ? NA_LOGICAL : (v != 0.0 ? 1 : 0);
        p_v[i] = 1;
        break;
      }
      case STRSXP: {
        stbl_chr_to_lgl_core(elem, 1, &p_r[i], &p_v[i]);
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
