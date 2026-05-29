#include <R.h>
#include <Rinternals.h>

/*
 * stbl_int_to_fct: public API entry point.
 *
 * Coerces an integer vector to a factor by first converting each value to its
 * decimal string representation, then matching against the target levels.
 *
 *   value:   integer vector to convert
 *   levels:  character vector of target levels, or R_NilValue (infer from
 *            data using the stringified integer values, sorted)
 *   ordered: length-1 logical; TRUE to produce an ordered factor
 *
 * Returns a named list of two vectors of length(value):
 *   $result: factor -- NA code for values whose string form is absent from
 *            levels (valid=FALSE) or NA in value (valid=TRUE)
 *   $valid:  logical -- FALSE for non-NA values whose string is not in levels
 */
SEXP stbl_int_to_fct(SEXP value, SEXP levels, SEXP ordered) {
  /* Convert integer to character, then delegate to stbl_chr_to_fct logic via
   * R_GetCCallable. We inline the equivalent here to avoid a hard dependency
   * on a registered callable at C-compile time. */
  SEXP chr_value = PROTECT(Rf_coerceVector(value, STRSXP));

  /* Forward the actual work to stbl_chr_to_fct via direct call. Declare the
   * prototype so the linker can resolve it at package load time. */
  extern SEXP stbl_chr_to_fct(SEXP, SEXP, SEXP);
  SEXP out = stbl_chr_to_fct(chr_value, levels, ordered);

  UNPROTECT(1);
  return out;
}
