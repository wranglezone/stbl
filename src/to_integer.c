#include "to.h"

SEXP stbl_chr_to_int(SEXP x);
SEXP stbl_cpx_to_int(SEXP x);
SEXP stbl_dbl_to_int(SEXP x);
SEXP stbl_fct_to_int(SEXP x);
SEXP stbl_lgl_to_int(SEXP x);
SEXP stbl_lst_to_int(SEXP x);

/**
 * @brief Coerce any supported vector to integer.
 *
 * Accepted source types and their behaviour:
 *   - integer:  returned unchanged (plain); factor level strings are parsed
 *               as integers.  Fails (via to_fail()) for non-numeric or fractional
 *               level strings.
 *   - logical:  FALSE -> 0L, TRUE -> 1L, NA -> NA_integer_.  Always succeeds.
 *   - double:   whole-number values are cast; Fails (via to_fail()) for fractional
 *               values, Inf, or values outside the 32-bit integer range.
 *   - character: parsed as double then truncated to integer.  Calls
 *               Rf_error() for non-numeric strings or fractional values.
 *   - complex:  real part converted if imaginary part is zero and real part is
 *               a whole number.  Raises the R-level to() error otherwise.
 *   - list:     each element is unwrapped to a scalar and converted by the
 *               same rules.  Raises the R-level to() error if any element is invalid.
 *
 * @param x  The vector to convert.
 * @param to,x_arg,call  Context forwarded to the R-level to() on failure.
 * @return   An integer vector of the same length as @p x.
 * @note     On failure, re-runs the R-level to() so the rlang error is thrown
 *           from one place.
 */
SEXP to_integer(SEXP x, SEXP to, SEXP x_arg, SEXP call) {
  int x_type = TYPEOF(x);
  SEXP res;

  if (x_type == INTSXP) {
    if (Rf_inherits(x, "factor")) {
      res = PROTECT(stbl_fct_to_int(x));
      SEXP out = check_int_cast(res, x, to, x_arg, call);
      UNPROTECT(1);
      return out;
    }
    return x;
  }
  if (x_type == LGLSXP) {
    res = PROTECT(stbl_lgl_to_int(x));
    SEXP out = result_of(res);
    UNPROTECT(1);
    return out;
  }
  if (x_type == REALSXP) {
    res = PROTECT(stbl_dbl_to_int(x));
    SEXP out = check_precision(res, x, to, x_arg, call);
    UNPROTECT(1);
    return out;
  }
  if (x_type == STRSXP) {
    res = PROTECT(stbl_chr_to_int(x));
    SEXP out = check_int_cast(res, x, to, x_arg, call);
    UNPROTECT(1);
    return out;
  }
  if (x_type == CPLXSXP) {
    res = PROTECT(stbl_cpx_to_int(x));
    SEXP out = check_int_cast(res, x, to, x_arg, call);
    UNPROTECT(1);
    return out;
  }
  if (x_type == VECSXP) {
    res = PROTECT(stbl_lst_to_int(x));
    SEXP out = check_valid(res, x, to, x_arg, call);
    UNPROTECT(1);
    return out;
  }
  return to_fail(x, to, x_arg, call);
}
