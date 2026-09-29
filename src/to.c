#include "to.h"

/*
 * stbl_to: coerce x to the type of to.
 *
 * Dispatches on typeof(to) and typeof(x), calling the appropriate C
 * conversion routine for unclassed logical, integer, double, and character
 * targets, and for factor targets.  All other targets (Date, POSIXct, hms,
 * Period, list, and any other classed prototype) are delegated to the
 * R-level to(), which dispatches to the appropriate to_*() function or
 * falls back to vctrs::vec_cast().
 *
 * When `to` is a factor its levels (if any) and ordered flag are respected:
 * levels are passed to the underlying stbl_*_to_fct() routine, so values
 * outside those levels produce Rf_error().  Pass a zero-length or levelless
 * factor() to infer levels from the data.
 *
 * NULL x is returned unchanged for all target types.
 *
 * On conversion failure of the C fast paths, Rf_error() is called with a
 * basic error message.  Targets delegated to the R-level to() produce its
 * richly formatted rlang errors.
 */
SEXP stbl_to(SEXP x, SEXP to) {
  int x_type  = TYPEOF(x);
  int to_type = TYPEOF(to);

  /* NULL input passes through unchanged */
  if (x_type == NILSXP) return x;

  if (to_type == INTSXP && Rf_inherits(to, "factor")) return to_factor(x, to);

  /* Fast C paths only apply to unclassed atomic targets */
  if (!Rf_isObject(to)) {
    switch (to_type) {
      case LGLSXP:  return to_logical(x);
      case INTSXP:  return to_integer(x);
      case REALSXP: return to_double(x);
      case STRSXP:  return to_character(x);
    }
  }

  /* Everything else delegates to the R-level to() */
  SEXP stbl_ns = R_FindNamespace(Rf_mkString("stbl"));
  SEXP call = PROTECT(Rf_lang3(Rf_install("to"), x, to));
  SEXP result = Rf_eval(call, stbl_ns);
  UNPROTECT(1);
  return result;
}
