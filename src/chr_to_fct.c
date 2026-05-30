
#include "stbl.h"
#include <R_ext/Utils.h>
#include <string.h>

/*
 * stbl_chr_to_fct: public API entry point.
 *
 * Coerces a character vector to a factor.
 *
 *   value:   character vector to convert
 *   levels:  character vector of target levels, or R_NilValue (infer from
 *            data using locale-aware sort(unique(value)), matching
 *            R's factor() semantics)
 *   ordered: length-1 logical; TRUE to produce an ordered factor
 *
 * Returns a named list of two vectors of length(value):
 *   $result: factor -- NA code for values absent from levels (valid=FALSE) or
 *            NA in value (valid=TRUE)
 *   $valid:  logical -- FALSE for non-NA values not present in levels
 */
SEXP stbl_chr_to_fct(SEXP value, SEXP levels, SEXP ordered) {
  R_xlen_t n = XLENGTH(value);
  int is_ordered = (!Rf_isNull(ordered) && LOGICAL(ordered)[0] == 1);

  SEXP lev;
  int own_levels = 0;

  if (Rf_isNull(levels)) {
    /* Collect unique non-NA CHARSXP pointers (R interns strings). */
    SEXP* uniq = (SEXP*) R_alloc(n, sizeof(SEXP));
    R_xlen_t nuniq = 0;
    for (R_xlen_t i = 0; i < n; i++) {
      SEXP xi = STRING_ELT(value, i);
      if (xi == NA_STRING) continue;
      int seen = 0;
      for (R_xlen_t j = 0; j < nuniq; j++) {
        if (uniq[j] == xi) { seen = 1; break; }
      }
      if (!seen) uniq[nuniq++] = xi;
    }
    /* Build a temporary STRSXP and sort it with locale-aware R_orderVector1. */
    SEXP tmp = PROTECT(Rf_allocVector(STRSXP, nuniq));
    for (R_xlen_t k = 0; k < nuniq; k++) SET_STRING_ELT(tmp, k, uniq[k]);
    int* order = (int*) R_alloc((size_t)nuniq, sizeof(int));
    R_orderVector1(order, (int)nuniq, tmp, TRUE, FALSE);
    lev = PROTECT(Rf_allocVector(STRSXP, nuniq));
    for (R_xlen_t k = 0; k < nuniq; k++)
      SET_STRING_ELT(lev, k, STRING_ELT(tmp, order[k]));
    UNPROTECT(1); /* tmp */
    own_levels = 1;
  } else {
    lev = levels;
  }

  R_xlen_t nlev = XLENGTH(lev);

  SEXP codes = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP valid = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_codes = INTEGER(codes);
  int* p_valid = LOGICAL(valid);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP xi = STRING_ELT(value, i);
    if (xi == NA_STRING) {
      p_codes[i] = NA_INTEGER;
      p_valid[i] = 1;
      continue;
    }
    int found = 0;
    for (R_xlen_t k = 0; k < nlev; k++) {
      /* R interns strings; pointer equality is a valid fast path. */
      if (STRING_ELT(lev, k) == xi) {
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

/*
 * stbl_chr_are_fctish: public API entry point.
 *
 * Checks whether each element of the character vector `x` can be coerced to a
 * factor with the given `levels` and `to_na` arguments.
 *
 *   x:      character vector to check
 *   levels: character vector of allowed levels, or R_NilValue (no constraint)
 *   to_na:  character vector of values that map to NA (treated as valid)
 *
 * When `levels` is NULL, every element (including NA) is factor-ish.
 * Otherwise an element is factor-ish iff it is NA (or in `to_na`) or it
 * appears in `levels`.
 *
 * Returns a logical vector of length(x).
 */
SEXP stbl_chr_are_fctish(SEXP x, SEXP levels, SEXP to_na) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(result);

  /* When levels is NULL every element is factor-ish */
  if (Rf_isNull(levels)) {
    for (R_xlen_t i = 0; i < n; i++) p[i] = 1;
    UNPROTECT(1);
    return result;
  }

  R_xlen_t nlev   = XLENGTH(levels);
  R_xlen_t n_tona = Rf_isNull(to_na) ? 0 : XLENGTH(to_na);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP xi = STRING_ELT(x, i);

    /* NA is always factor-ish */
    if (xi == NA_STRING) {
      p[i] = 1;
      continue;
    }

    /* Check to_na membership first */
    int in_tona = 0;
    for (R_xlen_t k = 0; k < n_tona && !in_tona; k++) {
      SEXP tk = STRING_ELT(to_na, k);
      if (tk != NA_STRING && xi == tk) in_tona = 1;
    }
    if (in_tona) {
      p[i] = 1; /* maps to NA, which is valid */
      continue;
    }

    /* Check levels membership */
    int in_levels = 0;
    for (R_xlen_t k = 0; k < nlev && !in_levels; k++) {
      SEXP lk = STRING_ELT(levels, k);
      if (lk != NA_STRING && xi == lk) in_levels = 1;
    }
    p[i] = in_levels;
  }

  UNPROTECT(1);
  return result;
}

