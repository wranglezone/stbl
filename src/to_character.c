#include "to.h"

SEXP stbl_dbl_to_chr(SEXP x);
SEXP stbl_fct_to_chr(SEXP x);
SEXP stbl_int_to_chr(SEXP x);
SEXP stbl_lgl_to_chr(SEXP x);
SEXP stbl_lst_to_chr(SEXP x);

/**
 * @brief Coerce any supported vector to character.
 *
 * Accepted source types and their behaviour:
 *   - character: returned unchanged.
 *   - integer:   formatted as decimal integers ("1", "-3", NA -> NA_character_).
 *                Always succeeds.
 *   - factor:    level label strings are extracted.  Always succeeds.
 *   - double:    formatted by R's default rules (same as as.character()).
 *                Always succeeds.
 *   - logical:   "TRUE", "FALSE", or NA_character_.  Always succeeds.
 *   - list:      each element must be a character scalar (or a one-element
 *                list/vector that unpacks to one).  Calls Rf_error() for
 *                elements that cannot be reduced to a single string.
 *
 * @param x  The vector to convert.
 * @return   A character vector of the same length as @p x.
 * @note     Calls Rf_error() on conversion failure.  For richly formatted
 *           rlang errors call the R-level to() instead.
 */
SEXP to_character(SEXP x) {
  int x_type = TYPEOF(x);
  SEXP res;

  if (x_type == STRSXP) return x;
  if (x_type == INTSXP) {
    if (Rf_inherits(x, "factor")) {
      res = PROTECT(stbl_fct_to_chr(x));
      SEXP out = result_of(res);
      UNPROTECT(1);
      return out;
    }
    res = PROTECT(stbl_int_to_chr(x));
    SEXP out = result_of(res);
    UNPROTECT(1);
    return out;
  }
  if (x_type == REALSXP) {
    res = PROTECT(stbl_dbl_to_chr(x));
    SEXP out = result_of(res);
    UNPROTECT(1);
    return out;
  }
  if (x_type == LGLSXP) {
    res = PROTECT(stbl_lgl_to_chr(x));
    SEXP out = result_of(res);
    UNPROTECT(1);
    return out;
  }
  if (x_type == VECSXP) {
    res = PROTECT(stbl_lst_to_chr(x));
    SEXP out = check_valid(res, "character");
    UNPROTECT(1);
    return out;
  }
  Rf_error("Can't convert to <character>.");
}
