#include "stbl.h"
#include <R_ext/Complex.h>

/*
 * stbl_lst_to_dbl: public API entry point.
 *
 * Converts a list to a named list:
 *   $result: double vector
 *   $valid:  logical vector -- TRUE for elements that were successfully
 *            converted, FALSE otherwise
 *
 * Two input shapes are accepted:
 *
 *   1. A flat list of scalars (any length).  Each element must be a
 *      length-1 atomic value coercible to double (or a singly-nested
 *      list that unwraps to one); elements that are not produce
 *      NA_real_ / valid = FALSE.
 *
 *   2. A one-element list whose single element is a coercible atomic
 *      vector of any length.  The vector is unpacked and each of its
 *      elements is processed individually, yielding an output of the
 *      same length as the vector.
 *
 * Coercion rules (per element, same as stbl_y_to_dbl):
 *   double    -> direct (always valid)
 *   integer   -> int_to_dbl (always valid)
 *   logical   -> lgl_to_dbl (always valid)
 *   character -> chr_to_dbl (valid if parseable as a number)
 *   complex   -> cpx_to_dbl (valid if Im == 0 or NA)
 *   factor    -> fct_to_dbl via level string (valid if level is numeric)
 *   nested list (VECSXP length 1) -> unwrap and apply above rules
 *   other / multi-element in a non-singleton list: NA_real_, valid = FALSE
 */

/* Fill p_r[0..m-1] and p_v[0..m-1] by unpacking the atomic vector elem. */
static void lst_to_dbl_fill_vec(SEXP elem, R_xlen_t m,
                                 double* p_r, int* p_v) {
  /* Factor: convert to dbl via level strings. */
  if (TYPEOF(elem) == INTSXP) {
    SEXP levels = Rf_getAttrib(elem, R_LevelsSymbol);
    if (!Rf_isNull(levels)) {
      SEXP lvl_strs = PROTECT(Rf_allocVector(STRSXP, m));
      int* codes = INTEGER(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        SET_STRING_ELT(lvl_strs, j,
          codes[j] == NA_INTEGER ? NA_STRING : STRING_ELT(levels, codes[j] - 1));
      }
      stbl_chr_to_dbl_core(lvl_strs, m, p_r, p_v);
      UNPROTECT(1);
      return;
    }
  }

  switch (TYPEOF(elem)) {
    case REALSXP: {
      double* src = REAL(elem);
      for (R_xlen_t j = 0; j < m; j++) { p_r[j] = src[j]; p_v[j] = 1; }
      break;
    }
    case INTSXP: {
      int* src = INTEGER(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        p_r[j] = (src[j] == NA_INTEGER) ? NA_REAL : (double)src[j];
        p_v[j] = 1;
      }
      break;
    }
    case LGLSXP: {
      int* src = LOGICAL(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        p_r[j] = (src[j] == NA_LOGICAL) ? NA_REAL : (double)src[j];
        p_v[j] = 1;
      }
      break;
    }
    case STRSXP: {
      stbl_chr_to_dbl_core(elem, m, p_r, p_v);
      break;
    }
    case CPLXSXP: {
      Rcomplex* cpx = COMPLEX(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        Rcomplex c = cpx[j];
        if (ISNAN(c.r) || ISNAN(c.i)) { p_r[j] = NA_REAL; p_v[j] = 1; }
        else if (c.i != 0.0) { p_r[j] = c.r; p_v[j] = 0; }
        else { p_r[j] = c.r; p_v[j] = 1; }
      }
      break;
    }
    /* default: caller already checked is_coercible; unreachable. */
  }
}

SEXP stbl_lst_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);

  /* Single-vector unpack: one-element list whose element is a coercible
   * atomic vector of length != 1. */
  if (n == 1) {
    SEXP elem = VECTOR_ELT(x, 0);
    R_xlen_t m = Rf_isVectorAtomic(elem) ? XLENGTH(elem) : 0;
    if (m != 1) {
      SEXPTYPE t = TYPEOF(elem);
      int coercible = (t == REALSXP || t == INTSXP || t == LGLSXP ||
                       t == STRSXP  || t == CPLXSXP);
      if (coercible) {
        SEXP result = PROTECT(Rf_allocVector(REALSXP, m));
        SEXP valid  = PROTECT(Rf_allocVector(LGLSXP,  m));
        lst_to_dbl_fill_vec(elem, m, REAL(result), LOGICAL(valid));
        SEXP out = stbl_lst_build_out(result, valid);
        UNPROTECT(2);
        return out;
      }
    }
  }

  /* Flat list of scalars: per-element logic with VECSXP unwrapping. */
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  double* p_r = REAL(result);
  int*    p_v = LOGICAL(valid);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP elem = stbl_lst_unwrap_elem(VECTOR_ELT(x, i));
    if (elem == R_NilValue || !Rf_isVectorAtomic(elem) || XLENGTH(elem) != 1) {
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

  SEXP out = stbl_lst_build_out(result, valid);
  UNPROTECT(2);
  return out;
}
