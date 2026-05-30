#include "stbl.h"
#include <R_ext/Utils.h>
#include <stdio.h>

/*
 * stbl_int_to_fct: public API entry point.
 *
 * Coerces an integer vector to a factor.  When `levels` is R_NilValue the
 * unique non-NA integers are collected and sorted *numerically* (via
 * R_orderVector1 on an INTSXP), then converted to character level labels.
 * This matches the ordering produced by R's factor(integer_vector) and is
 * superior to lexicographic string sorting for integer inputs (e.g., the
 * levels of 1:10 come out as "1","2",..."10", not "1","10","2",...).
 *
 *   value:   integer vector to convert
 *   levels:  character vector of target levels, or R_NilValue (infer from
 *            data, sorted numerically)
 *   ordered: length-1 logical; TRUE to produce an ordered factor
 *
 * Returns a named list of two vectors of length(value):
 *   $result: factor
 *   $valid:  logical -- FALSE for non-NA values whose string is not in levels
 */
SEXP stbl_int_to_fct(SEXP value, SEXP levels, SEXP ordered) {
  R_xlen_t n = XLENGTH(value);
  int is_ordered = (!Rf_isNull(ordered) && LOGICAL(ordered)[0] == 1);
  int* px = INTEGER(value);

  SEXP lev;
  int own_levels = 0;

  /* Scratch buffer large enough for any 32-bit integer as a string. */
  char buf[32];

  if (Rf_isNull(levels)) {
    /* First pass: collect unique non-NA integers. */
    int* uniq = (int*) R_alloc(n, sizeof(int));
    R_xlen_t nuniq = 0;
    for (R_xlen_t i = 0; i < n; i++) {
      int xi = px[i];
      if (xi == NA_INTEGER) continue;
      int seen = 0;
      for (R_xlen_t j = 0; j < nuniq; j++) {
        if (uniq[j] == xi) { seen = 1; break; }
      }
      if (!seen) uniq[nuniq++] = xi;
    }
    /* Sort numerically via R_orderVector1 on a temporary INTSXP. */
    SEXP tmp = PROTECT(Rf_allocVector(INTSXP, nuniq));
    for (R_xlen_t k = 0; k < nuniq; k++) INTEGER(tmp)[k] = uniq[k];
    int* order = (int*) R_alloc((size_t)nuniq, sizeof(int));
    R_orderVector1(order, (int)nuniq, tmp, TRUE, FALSE);
    /* Build levels STRSXP from the sorted unique integers. */
    lev = PROTECT(Rf_allocVector(STRSXP, nuniq));
    for (R_xlen_t k = 0; k < nuniq; k++) {
      snprintf(buf, sizeof(buf), "%d", uniq[order[k]]);
      SET_STRING_ELT(lev, k, Rf_mkChar(buf));
    }
    UNPROTECT(1); /* tmp */
    own_levels = 1;
  } else {
    lev = levels; /* caller-provided character levels */
  }

  R_xlen_t nlev = XLENGTH(lev);

  SEXP codes = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP valid = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_codes = INTEGER(codes);
  int* p_valid = LOGICAL(valid);

  for (R_xlen_t i = 0; i < n; i++) {
    int xi = px[i];
    if (xi == NA_INTEGER) {
      p_codes[i] = NA_INTEGER;
      p_valid[i] = 1;
      continue;
    }
    /* Format this value and look it up in the levels vector.
     * R interns strings, so Rf_mkChar("1") == STRING_ELT(lev, k) when they
     * hold the same characters — pointer equality is a valid fast path. */
    snprintf(buf, sizeof(buf), "%d", xi);
    SEXP xi_str = Rf_mkChar(buf); /* intern; no PROTECT needed for comparison */
    int found = 0;
    for (R_xlen_t k = 0; k < nlev; k++) {
      if (STRING_ELT(lev, k) == xi_str) {
        p_codes[i] = (int)(k + 1);
        p_valid[i] = 1;
        found = 1;
        break;
      }
    }
    if (!found) {
      p_codes[i] = NA_INTEGER;
      p_valid[i] = 0;
    }
  }

  stbl_set_factor_attribs(codes, lev, is_ordered);

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SET_VECTOR_ELT(out, 0, codes);
  SET_VECTOR_ELT(out, 1, valid);
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_STRING_ELT(names, 0, Rf_mkChar("result"));
  SET_STRING_ELT(names, 1, Rf_mkChar("valid"));
  Rf_setAttrib(out, R_NamesSymbol, names);
  UNPROTECT(own_levels ? 5 : 4);
  return out;
}
