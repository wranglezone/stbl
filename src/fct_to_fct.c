#include <R.h>
#include <Rinternals.h>

/*
 * stbl_fct_are_fctish: public API entry point.
 *
 * Checks whether each element of the factor `x` can be coerced to a factor
 * with the given `levels` and `to_na` arguments.
 *
 *   x:      factor to check
 *   levels: character vector of allowed target levels, or R_NilValue
 *   to_na:  character vector of values that map to NA (treated as valid)
 *
 * The check is performed on the factor's own levels (character strings) mapped
 * via integer codes, avoiding materialisation of as.character(x).
 *
 * Returns a logical vector of length(x).
 */
SEXP stbl_fct_are_fctish(SEXP x, SEXP levels, SEXP to_na) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(result);

  /* When levels is NULL every element is factor-ish */
  if (Rf_isNull(levels)) {
    for (R_xlen_t i = 0; i < n; i++) p[i] = 1;
    UNPROTECT(1);
    return result;
  }

  SEXP fct_levels = Rf_getAttrib(x, R_LevelsSymbol);
  R_xlen_t nlev_fct = Rf_isNull(fct_levels) ? 0 : XLENGTH(fct_levels);
  R_xlen_t nlev_tgt = XLENGTH(levels);
  R_xlen_t n_tona   = Rf_isNull(to_na) ? 0 : XLENGTH(to_na);

  /* Pre-compute validity for each factor level */
  int* level_valid = (int*) R_alloc(nlev_fct, sizeof(int));
  for (R_xlen_t k = 0; k < nlev_fct; k++) {
    SEXP lk = STRING_ELT(fct_levels, k);

    /* Check to_na */
    int in_tona = 0;
    for (R_xlen_t j = 0; j < n_tona && !in_tona; j++) {
      SEXP tj = STRING_ELT(to_na, j);
      if (tj != NA_STRING && lk == tj) in_tona = 1;
    }
    if (in_tona) { level_valid[k] = 1; continue; }

    /* Check target levels */
    int in_levels = 0;
    for (R_xlen_t j = 0; j < nlev_tgt && !in_levels; j++) {
      SEXP tj = STRING_ELT(levels, j);
      if (tj != NA_STRING && lk == tj) in_levels = 1;
    }
    level_valid[k] = in_levels;
  }

  /* Map codes to per-element results */
  int* codes = INTEGER(x);
  for (R_xlen_t i = 0; i < n; i++) {
    int code = codes[i];
    if (code == NA_INTEGER) {
      p[i] = 1; /* NA is always factor-ish */
    } else {
      p[i] = level_valid[(R_xlen_t)(code - 1)];
    }
  }

  UNPROTECT(1);
  return result;
}
