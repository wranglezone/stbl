#include "to.h"

SEXP stbl_chr_to_dbl(SEXP x);
SEXP stbl_cpx_to_dbl(SEXP x);
SEXP stbl_fct_to_dbl(SEXP x);
SEXP stbl_int_to_dbl(SEXP x);
SEXP stbl_lgl_to_dbl(SEXP x);
SEXP stbl_lst_to_dbl(SEXP x);

/**
 * @brief Coerce any supported vector to double.
 *
 * Accepted source types and their behaviour:
 *   - double:   returned unchanged.
 *   - integer:  cast to double.  Always succeeds.
 *   - factor:   level strings are parsed as double.  Fails (via to_fail()) for
 *               any non-numeric level string.
 *   - logical:  FALSE -> 0.0, TRUE -> 1.0, NA -> NA_real_.  Always succeeds.
 *   - character: parsed via strtod.  Fails (via to_fail()) for non-numeric strings
 *               (NaN is treated as non-numeric and also errors).
 *   - complex:  real part extracted when imaginary part is zero.  Calls
 *               Rf_error() for non-zero imaginary parts.
 *   - list:     each element is unwrapped to a scalar and converted by the
 *               same rules.  Raises the R-level to() error if any element is invalid.
 *
 * @param x  The vector to convert.
 * @param to,x_arg,call  Context forwarded to the R-level to() on failure.
 * @return   A double vector of the same length as @p x.
 * @note     On failure, re-runs the R-level to() so the rlang error is thrown
 *           from one place.
 */
SEXP to_double(SEXP x, SEXP to, SEXP x_arg, SEXP call) {
  int x_type = TYPEOF(x);
  SEXP res;

  if (x_type == REALSXP) return x;
  if (x_type == INTSXP) {
    if (Rf_inherits(x, "factor")) {
      res = PROTECT(stbl_fct_to_dbl(x));
      SEXP out = check_valid(res, x, to, x_arg, call);
      UNPROTECT(1);
      return out;
    }
    res = PROTECT(stbl_int_to_dbl(x));
    SEXP out = result_of(res);
    UNPROTECT(1);
    return out;
  }
  if (x_type == LGLSXP) {
    res = PROTECT(stbl_lgl_to_dbl(x));
    SEXP out = result_of(res);
    UNPROTECT(1);
    return out;
  }
  if (x_type == STRSXP) {
    res = PROTECT(stbl_chr_to_dbl(x));
    SEXP out = check_valid(res, x, to, x_arg, call);
    UNPROTECT(1);
    return out;
  }
  if (x_type == CPLXSXP) {
    res = PROTECT(stbl_cpx_to_dbl(x));
    SEXP out = check_valid(res, x, to, x_arg, call);
    UNPROTECT(1);
    return out;
  }
  if (x_type == VECSXP) {
    res = PROTECT(stbl_lst_to_dbl(x));
    SEXP out = check_valid(res, x, to, x_arg, call);
    UNPROTECT(1);
    return out;
  }
  return to_fail(x, to, x_arg, call);
}
