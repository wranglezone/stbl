#include <R.h>
#include <Rinternals.h>

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
