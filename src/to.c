#include "to.h"

/*
 * stbl_to: convert x to the type of to.
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
 * outside those levels raise the R-level to() error.  Pass a zero-length or levelless
 * factor() to infer levels from the data.
 *
 * NULL x is returned unchanged for all target types.
 *
 * `x_arg` and `to_arg` (strings) and `call` (a call or environment) give error
 * context; pass R_NilValue for any of them to use to()'s defaults.  On
 * conversion failure of the C fast paths the R-level to() is re-run on the
 * original `x`, so errors have the same classes, message, and fields as the R 
 * path.
 */
/*
 * Evaluate the R-level to(x, .to, x_arg = x_arg, to_arg = to_arg, call = call).
 * Values are bound in an environment (not spliced into the call) so that 
 * language-valued inputs are treated as data.  NULL x_arg/call are omitted so 
 * to() uses its defaults.
 */
static SEXP eval_r_to(SEXP x, SEXP to, SEXP x_arg, SEXP to_arg, SEXP call) {
  SEXP stbl_ns = R_FindNamespace(Rf_mkString("stbl"));
  SEXP env = PROTECT(R_NewEnv(stbl_ns, 0, 0));
  Rf_defineVar(Rf_install("x"), x, env);
  Rf_defineVar(Rf_install(".to"), to, env);

  SEXP args = PROTECT(Rf_cons(Rf_install(".to"), R_NilValue));
  if (!Rf_isNull(x_arg)) {
    Rf_defineVar(Rf_install("x_arg"), x_arg, env);
    SEXP cell = PROTECT(Rf_cons(Rf_install("x_arg"), R_NilValue));
    SET_TAG(cell, Rf_install("x_arg"));
    SETCDR(args, cell);
    UNPROTECT(1);
  }
  /* Always bound, even when NULL, so to() doesn't derive a to_arg from the
   * internal `.to` symbol. */
  Rf_defineVar(Rf_install("to_arg"), to_arg, env);
  {
    SEXP cell = PROTECT(Rf_cons(Rf_install("to_arg"), R_NilValue));
    SET_TAG(cell, Rf_install("to_arg"));
    SEXP last = args;
    while (CDR(last) != R_NilValue) last = CDR(last);
    SETCDR(last, cell);
    UNPROTECT(1);
  }
  if (!Rf_isNull(call)) {
    Rf_defineVar(Rf_install("call"), call, env);
    SEXP cell = PROTECT(Rf_cons(Rf_install("call"), R_NilValue));
    SET_TAG(cell, Rf_install("call"));
    SEXP last = args;
    while (CDR(last) != R_NilValue) last = CDR(last);
    SETCDR(last, cell);
    UNPROTECT(1);
  }
  SEXP fcall = PROTECT(Rf_lcons(Rf_install("to"), Rf_cons(Rf_install("x"), args)));
  SEXP result = Rf_eval(fcall, env);
  UNPROTECT(3);
  return result;
}

SEXP to_fail(SEXP x, SEXP to, SEXP x_arg, SEXP to_arg, SEXP call) {
  return eval_r_to(x, to, x_arg, to_arg, call);
}

SEXP stbl_to(SEXP x, SEXP to, SEXP x_arg, SEXP to_arg, SEXP call) {
  int x_type  = TYPEOF(x);
  int to_type = TYPEOF(to);

  /* NULL input passes through unchanged */
  if (x_type == NILSXP) return x;

  if (to_type == INTSXP && Rf_inherits(to, "factor")) return to_factor(x, to, x_arg, to_arg, call);

  /* Fast C paths only apply to plain atomic targets: no class and no dim
   * (matrices/arrays are not marked as R objects but still need the R-level
   * path to preserve dimensions). */
  if (!Rf_isObject(to) && Rf_getAttrib(to, R_DimSymbol) == R_NilValue) {
    switch (to_type) {
      case LGLSXP:  return to_logical(x, to, x_arg, to_arg, call);
      case INTSXP:  return to_integer(x, to, x_arg, to_arg, call);
      case REALSXP: return to_double(x, to, x_arg, to_arg, call);
      case STRSXP:  return to_character(x, to, x_arg, to_arg, call);
    }
  }

  /* Everything else delegates to the R-level to(). */
  return eval_r_to(x, to, x_arg, to_arg, call);
}
