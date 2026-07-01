#include "to.h"

/*
 * stbl_to: coerce x to the type of to.
 *
 * Dispatches on typeof(to) and typeof(x), calling the appropriate C
 * conversion routine.  Supported target types: logical, integer, double,
 * character, factor.  List targets are not handled here; use the R-level
 * to() wrapper, which delegates that case to to_lst().
 *
 * When `to` is a factor its levels (if any) and ordered flag are respected:
 * levels are passed to the underlying stbl_*_to_fct() routine, so values
 * outside those levels produce Rf_error().  Pass a zero-length or levelless
 * factor() to infer levels from the data.
 *
 * NULL x is returned unchanged for all target types.
 *
 * On conversion failure Rf_error() is called with a basic error message.
 * For richly formatted rlang errors, call the R-level to() instead.
 */
SEXP stbl_to(SEXP x, SEXP to) {
  int x_type  = TYPEOF(x);
  int to_type = TYPEOF(to);

  /* NULL input passes through unchanged */
  if (x_type == NILSXP) return x;

  if (to_type == INTSXP && Rf_inherits(to, "factor")) return to_factor(x, to);
  if (to_type == VECSXP) {
    Rf_error("List targets are not supported by stbl_to(); use to() from R.");
  }

  switch (to_type) {
    case LGLSXP:  return to_logical(x);
    case INTSXP:  return to_integer(x);
    case REALSXP: return to_double(x);
    case STRSXP:  return to_character(x);
    default:
      Rf_error("Unsupported target type in stbl_to().");
  }
}
