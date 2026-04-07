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
 * Returns a logical vector of length(x). Handles REALSXP and INTSXP inputs.
 * 0 -> FALSE, non-zero -> TRUE, NA/NaN -> NA.
 */
SEXP stbl_dbl_to_lgl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  dbl_to_lgl_core(x, n, LOGICAL(result));
  UNPROTECT(1);
  return result;
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
