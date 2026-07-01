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
 *               Calls Rf_error() for any unparseable level.
 *   - double:   0.0/NaN/NA_real_ -> FALSE/NA/NA, non-zero -> TRUE.  Always
 *               succeeds.
 *   - character: "TRUE"/"T"/"1" -> TRUE, "FALSE"/"F"/"0" -> FALSE
 *               (case-insensitive).  Calls Rf_error() for anything else.
 *   - list:     each element is unwrapped to a scalar and converted by the
 *               same rules.  Calls Rf_error() if any element is invalid.
 *
 * @param x  The vector to convert.
 * @return   A logical vector of the same length as @p x.
 * @note     Calls Rf_error() on conversion failure.  For richly formatted
 *           rlang errors call the R-level to() instead.
 */
SEXP to_logical(SEXP x) {
  int x_type = TYPEOF(x);
  SEXP res;

  if (x_type == LGLSXP) return x;
  if (x_type == INTSXP) {
    if (Rf_inherits(x, "factor")) {
      res = PROTECT(stbl_fct_to_lgl(x));
      SEXP out = check_valid(res, "logical");
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
    SEXP out = check_valid(res, "logical");
    UNPROTECT(1);
    return out;
  }
  if (x_type == VECSXP) {
    res = PROTECT(stbl_lst_to_lgl(x));
    SEXP out = check_valid(res, "logical");
    UNPROTECT(1);
    return out;
  }
  Rf_error("Can't convert to <logical>.");
}
