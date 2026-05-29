#include "stbl.h"
#include <R_ext/Complex.h>
#include <math.h>

/*
 * stbl_lst_to_int: public API entry point.
 *
 * Converts a list to a named list:
 *   $result: integer vector
 *   $valid:  logical vector -- TRUE for elements that were successfully
 *            converted, FALSE otherwise
 *
 * Two input shapes are accepted:
 *
 *   1. A flat list of scalars (any length).  Each element must be a
 *      length-1 atomic value coercible to integer; elements that are not
 *      produce NA_integer_ / valid = FALSE.
 *
 *   2. A one-element list whose single element is a coercible atomic
 *      vector of any length.  The vector is unpacked and each of its
 *      elements is processed individually, yielding an output of the
 *      same length as the vector.
 *
 * Coercion rules (per element, same as stbl_y_to_int):
 *   integer   -> direct (always valid)
 *   logical   -> lgl_to_int (always valid)
 *   double    -> dbl_to_int (valid if whole number in R's integer range)
 *   character -> chr_to_int (valid if parseable as a whole number)
 *   complex   -> cpx_to_int (valid if Im == 0 and Re is a whole number)
 *   factor    -> fct_to_int via level string (valid if level is a whole number)
 *   other / multi-element in a non-singleton list: NA_integer_, valid = FALSE
 */

/* Fill p_r[0..m-1] and p_v[0..m-1] by unpacking the atomic vector elem. */
static void lst_to_int_fill_vec(SEXP elem, R_xlen_t m, int* p_r, int* p_v) {
  /* Factor: convert to int via level strings. */
  if (TYPEOF(elem) == INTSXP) {
    SEXP levels = Rf_getAttrib(elem, R_LevelsSymbol);
    if (!Rf_isNull(levels)) {
      SEXP lvl_strs = PROTECT(Rf_allocVector(STRSXP, m));
      int* codes = INTEGER(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        SET_STRING_ELT(lvl_strs, j,
          codes[j] == NA_INTEGER ? NA_STRING : STRING_ELT(levels, codes[j] - 1));
      }
      int* p_nn = (int*)R_alloc(m, sizeof(int));
      int* p_bp = (int*)R_alloc(m, sizeof(int));
      stbl_chr_to_int_core(lvl_strs, m, p_r, p_nn, p_bp);
      for (R_xlen_t j = 0; j < m; j++) p_v[j] = !p_nn[j] && !p_bp[j];
      UNPROTECT(1);
      return;
    }
  }

  switch (TYPEOF(elem)) {
    case INTSXP: {
      int* src = INTEGER(elem);
      for (R_xlen_t j = 0; j < m; j++) { p_r[j] = src[j]; p_v[j] = 1; }
      break;
    }
    case LGLSXP: {
      int* src = LOGICAL(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        p_r[j] = (src[j] == NA_LOGICAL) ? NA_INTEGER : src[j];
        p_v[j] = 1;
      }
      break;
    }
    case REALSXP: {
      double* src = REAL(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        double v = src[j];
        if (ISNAN(v)) { p_r[j] = NA_INTEGER; p_v[j] = 1; }
        else if (!R_FINITE(v) || v < STBL_INT_MIN || v > STBL_INT_MAX ||
                 v != floor(v)) {
          p_r[j] = NA_INTEGER; p_v[j] = 0;
        } else { p_r[j] = (int)v; p_v[j] = 1; }
      }
      break;
    }
    case STRSXP: {
      int* p_nn = (int*)R_alloc(m, sizeof(int));
      int* p_bp = (int*)R_alloc(m, sizeof(int));
      stbl_chr_to_int_core(elem, m, p_r, p_nn, p_bp);
      for (R_xlen_t j = 0; j < m; j++) p_v[j] = !p_nn[j] && !p_bp[j];
      break;
    }
    case CPLXSXP: {
      Rcomplex* cpx = COMPLEX(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        Rcomplex c = cpx[j];
        if (ISNAN(c.r) || ISNAN(c.i)) { p_r[j] = NA_INTEGER; p_v[j] = 1; }
        else if (c.i != 0.0) { p_r[j] = NA_INTEGER; p_v[j] = 0; }
        else {
          double r = c.r;
          if (!R_FINITE(r) || r < STBL_INT_MIN || r > STBL_INT_MAX ||
              r != floor(r)) {
            p_r[j] = NA_INTEGER; p_v[j] = 0;
          } else { p_r[j] = (int)r; p_v[j] = 1; }
        }
      }
      break;
    }
    /* default: caller already checked is_coercible; unreachable. */
  }
}

/* Build the standard list(result, valid) output SEXP. Caller must have
 * already PROTECTed result and valid. */
static SEXP lst_to_int_build_out(SEXP result, SEXP valid) {
  SEXP out   = PROTECT(Rf_allocVector(VECSXP, 2));
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_VECTOR_ELT(out, 0, result);
  SET_VECTOR_ELT(out, 1, valid);
  SET_STRING_ELT(names, 0, Rf_mkChar("result"));
  SET_STRING_ELT(names, 1, Rf_mkChar("valid"));
  Rf_setAttrib(out, R_NamesSymbol, names);
  UNPROTECT(2);
  return out;
}

SEXP stbl_lst_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);

  /* Single-vector unpack: one-element list whose element is a coercible
   * atomic vector of length != 1. */
  if (n == 1) {
    SEXP elem = VECTOR_ELT(x, 0);
    R_xlen_t m = XLENGTH(elem);
    if (m != 1) {
      SEXPTYPE t = TYPEOF(elem);
      int coercible = (t == INTSXP || t == LGLSXP || t == REALSXP ||
                       t == STRSXP || t == CPLXSXP);
      if (coercible) {
        SEXP result = PROTECT(Rf_allocVector(INTSXP, m));
        SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, m));
        lst_to_int_fill_vec(elem, m, INTEGER(result), LOGICAL(valid));
        SEXP out = lst_to_int_build_out(result, valid);
        UNPROTECT(2);
        return out;
      }
    }
  }

  /* Flat list of scalars: existing per-element logic. */
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

  SEXP out = lst_to_int_build_out(result, valid);
  UNPROTECT(2);
  return out;
}
