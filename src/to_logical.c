#include "to.h"

SEXP stbl_chr_to_lgl(SEXP x);
SEXP stbl_dbl_to_lgl(SEXP x);
SEXP stbl_fct_to_lgl(SEXP x);
SEXP stbl_lst_to_lgl(SEXP x);

/**
 * @brief Coerce any supported vector to logical.
 *
 * Accepted source types and their behaviour:
 *   - logical:  returned unchanged.
 *   - integer:  0L -> FALSE, non-zero -> TRUE, NA -> NA.  All values are
 *               valid; conversion never fails.
 *   - factor:   level strings are parsed as logical (same rules as character).
 *               Fails (via to_fail()) for any unparseable level.
 *   - double:   0.0/NaN/NA_real_ -> FALSE/NA/NA, non-zero -> TRUE.  Always
 *               succeeds.
 *   - character: "TRUE"/"T"/"1" -> TRUE, "FALSE"/"F"/"0" -> FALSE
 *               (case-insensitive).  Fails (via to_fail()) for anything else.
 *   - list:     each element is unwrapped to a scalar and converted by the
 *               same rules.  Raises the R-level to() error if any element is invalid.
 *
 * @param x  The vector to convert.
 * @param to,x_arg,call  Context forwarded to the R-level to() on failure.
 * @return   A logical vector of the same length as @p x.
 * @note     On failure, re-runs the R-level to() so the rlang error is thrown
 *           from one place.
 */
SEXP to_logical(SEXP x, SEXP to, SEXP x_arg, SEXP call) {
  int x_type = TYPEOF(x);
  SEXP res;

  if (x_type == LGLSXP) return x;
  if (x_type == INTSXP) {
    if (Rf_inherits(x, "factor")) {
      res = PROTECT(stbl_fct_to_lgl(x));
      SEXP out = check_valid(res, x, to, x_arg, call);
      UNPROTECT(1);
      return out;
    }
    /* plain integer: stbl_dbl_to_lgl handles INTSXP inputs */
    res = PROTECT(stbl_dbl_to_lgl(x));
    SEXP out = result_of(res);
    UNPROTECT(1);
    return out;
  }
  if (x_type == REALSXP) {
    res = PROTECT(stbl_dbl_to_lgl(x));
    SEXP out = result_of(res);
    UNPROTECT(1);
    return out;
  }
  if (x_type == STRSXP) {
    res = PROTECT(stbl_chr_to_lgl(x));
    SEXP out = check_valid(res, x, to, x_arg, call);
    UNPROTECT(1);
    return out;
  }
  if (x_type == VECSXP) {
    res = PROTECT(stbl_lst_to_lgl(x));
    SEXP out = check_valid(res, x, to, x_arg, call);
    UNPROTECT(1);
    return out;
  }
  return to_fail(x, to, x_arg, call);
}
