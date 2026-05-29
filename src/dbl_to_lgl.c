#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>

/*
 * Core single-pass double/integer-to-logical conversion.
 *
 * Handles both REALSXP and INTSXP inputs so that this function is safe to
 * call from to_lgl.numeric(), which receives integers dispatched via the
 * numeric class hierarchy.
 *
 * Conversion rules (matching as.logical()):
 *   0 or 0.0  -> FALSE
 *   non-zero  -> TRUE
 *   NA / NaN  -> NA_LOGICAL
 */
static void dbl_to_lgl_core(SEXP x, R_xlen_t n, int* p_result) {
  if (TYPEOF(x) == REALSXP) {
    double* px = REAL(x);
    for (R_xlen_t i = 0; i < n; i++) {
      if (ISNAN(px[i])) {
        p_result[i] = NA_LOGICAL;
      } else {
        p_result[i] = (px[i] != 0.0) ? 1 : 0;
      }
    }
  } else {
    /* INTSXP: integers dispatched through the numeric S3 hierarchy */
    int* px = INTEGER(x);
    for (R_xlen_t i = 0; i < n; i++) {
      p_result[i] = (px[i] == NA_INTEGER) ? NA_LOGICAL : (px[i] != 0 ? 1 : 0);
    }
  }
}

/*
 * stbl_dbl_to_lgl: public API entry point.
 *
 * Returns a named list of two vectors of length(x):
 *   $result: logical -- 0 -> FALSE, non-zero -> TRUE, NA/NaN -> NA
 *   $valid:  logical -- always TRUE (every double/integer is lgl-ish)
 *
 * Handles REALSXP and INTSXP inputs.
 */
SEXP stbl_dbl_to_lgl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  dbl_to_lgl_core(x, n, LOGICAL(result));

  SEXP valid = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(valid);
  for (R_xlen_t i = 0; i < n; i++) p[i] = 1;

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

/*
 * stbl_dbl_are_lglish: public API entry point.
 *
 * All numeric values (including NA/NaN) are logical-ish. Returns a logical
 * vector of length(x) filled with TRUE.
 */
SEXP stbl_dbl_are_lglish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p = LOGICAL(result);
  for (R_xlen_t i = 0; i < n; i++) p[i] = 1;
  UNPROTECT(1);
  return result;
}
