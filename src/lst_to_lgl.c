#include "stbl.h"

/*
 * stbl_lst_to_lgl: public API entry point.
 *
 * Converts a list to a named list:
 *   $result: logical vector
 *   $valid:  logical vector -- TRUE for elements that were successfully
 *            converted, FALSE otherwise
 *
 * Two input shapes are accepted:
 *
 *   1. A flat list of scalars (any length).  Each element must be a
 *      length-1 atomic value coercible to logical; elements that are not
 *      produce NA / valid = FALSE.
 *
 *   2. A one-element list whose single element is a coercible atomic
 *      vector of any length.  The vector is unpacked and each of its
 *      elements is processed individually, yielding an output of the
 *      same length as the vector.
 *
 * Coercion rules (per element, same as stbl_y_to_lgl):
 *   logical   -> direct (always valid)
 *   integer   -> dbl_to_lgl integer path (always valid)
 *   double    -> dbl_to_lgl (always valid)
 *   character -> chr_to_lgl (valid if TRUE/FALSE/T/F/numeric string)
 *   factor    -> fct_to_lgl via level string (valid if level is lgl-ish)
 *   other / multi-element in a non-singleton list: NA, valid = FALSE
 */

/* Fill p_r[0..m-1] and p_v[0..m-1] by unpacking the atomic vector elem. */
static void lst_to_lgl_fill_vec(SEXP elem, R_xlen_t m, int* p_r, int* p_v) {
  /* Factor: convert to lgl via level strings. */
  if (TYPEOF(elem) == INTSXP) {
    SEXP levels = Rf_getAttrib(elem, R_LevelsSymbol);
    if (!Rf_isNull(levels)) {
      SEXP lvl_strs = PROTECT(Rf_allocVector(STRSXP, m));
      int* codes = INTEGER(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        SET_STRING_ELT(lvl_strs, j,
          codes[j] == NA_INTEGER ? NA_STRING : STRING_ELT(levels, codes[j] - 1));
      }
      stbl_chr_to_lgl_core(lvl_strs, m, p_r, p_v);
      UNPROTECT(1);
      return;
    }
  }

  switch (TYPEOF(elem)) {
    case LGLSXP: {
      int* src = LOGICAL(elem);
      for (R_xlen_t j = 0; j < m; j++) { p_r[j] = src[j]; p_v[j] = 1; }
      break;
    }
    case INTSXP: {
      int* src = INTEGER(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        p_r[j] = (src[j] == NA_INTEGER) ? NA_LOGICAL : (src[j] != 0 ? 1 : 0);
        p_v[j] = 1;
      }
      break;
    }
    case REALSXP: {
      double* src = REAL(elem);
      for (R_xlen_t j = 0; j < m; j++) {
        p_r[j] = ISNAN(src[j]) ? NA_LOGICAL : (src[j] != 0.0 ? 1 : 0);
        p_v[j] = 1;
      }
      break;
    }
    case STRSXP: {
      stbl_chr_to_lgl_core(elem, m, p_r, p_v);
      break;
    }
    /* default: caller already checked is_coercible; unreachable. */
  }
}

/* Build the standard list(result, valid) output SEXP. Caller must have
 * already PROTECTed result and valid. */
static SEXP lst_to_lgl_build_out(SEXP result, SEXP valid) {
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

SEXP stbl_lst_to_lgl(SEXP x) {
  R_xlen_t n = XLENGTH(x);

  /* Single-vector unpack: one-element list whose element is a coercible
   * atomic vector of length != 1. */
  if (n == 1) {
    SEXP elem = VECTOR_ELT(x, 0);
    R_xlen_t m = XLENGTH(elem);
    if (m != 1) {
      SEXPTYPE t = TYPEOF(elem);
      int coercible = (t == LGLSXP || t == INTSXP ||
                       t == REALSXP || t == STRSXP);
      if (coercible) {
        SEXP result = PROTECT(Rf_allocVector(LGLSXP, m));
        SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, m));
        lst_to_lgl_fill_vec(elem, m, LOGICAL(result), LOGICAL(valid));
        SEXP out = lst_to_lgl_build_out(result, valid);
        UNPROTECT(2);
        return out;
      }
    }
  }

  /* Flat list of scalars: existing per-element logic. */
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

  SEXP out = lst_to_lgl_build_out(result, valid);
  UNPROTECT(2);
  return out;
}
