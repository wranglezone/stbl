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
 *               as integers.  Calls Rf_error() for non-numeric or fractional
 *               level strings.
 *   - logical:  FALSE -> 0L, TRUE -> 1L, NA -> NA_integer_.  Always succeeds.
 *   - double:   whole-number values are cast; Calls Rf_error() for fractional
 *               values, Inf, or values outside the 32-bit integer range.
 *   - character: parsed as double then truncated to integer.  Calls
 *               Rf_error() for non-numeric strings or fractional values.
 *   - complex:  real part converted if imaginary part is zero and real part is
 *               a whole number.  Calls Rf_error() otherwise.
 *   - list:     each element is unwrapped to a scalar and converted by the
 *               same rules.  Calls Rf_error() if any element is invalid.
 *
 * @param x  The vector to convert.
 * @return   An integer vector of the same length as @p x.
 * @note     Calls Rf_error() on conversion failure.  For richly formatted
 *           rlang errors call the R-level to() instead.
 */
SEXP to_integer(SEXP x) {
  int x_type = TYPEOF(x);
  SEXP res;

  if (x_type == INTSXP) {
    if (Rf_inherits(x, "factor")) {
      res = PROTECT(stbl_fct_to_int(x));
      SEXP out = check_int_cast(res, "factor");
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
    SEXP out = check_precision(res, "double");
    UNPROTECT(1);
    return out;
  }
  if (x_type == STRSXP) {
    res = PROTECT(stbl_chr_to_int(x));
    SEXP out = check_int_cast(res, "character");
    UNPROTECT(1);
    return out;
  }
  if (x_type == CPLXSXP) {
    res = PROTECT(stbl_cpx_to_int(x));
    SEXP out = check_int_cast(res, "complex");
    UNPROTECT(1);
    return out;
  }
  if (x_type == VECSXP) {
    res = PROTECT(stbl_lst_to_int(x));
    SEXP out = check_valid(res, "integer");
    UNPROTECT(1);
    return out;
  }
  Rf_error("Can't convert to <integer>.");
}
