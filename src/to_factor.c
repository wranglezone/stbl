#include "to.h"

SEXP stbl_chr_to_fct(SEXP value, SEXP levels, SEXP ordered);
SEXP stbl_dbl_to_chr(SEXP x);
SEXP stbl_fct_to_chr(SEXP x);
SEXP stbl_int_to_fct(SEXP value, SEXP levels, SEXP ordered);
SEXP stbl_lgl_to_chr(SEXP x);
SEXP stbl_lst_to_fct(SEXP x);

/**
 * @brief Coerce any supported vector to factor, using @p to as a template.
 *
 * Levels and ordered-ness are read from @p to:
 *   - If @p to has a non-empty levels attribute those levels are enforced;
 *     values absent from the levels cause Rf_error().
 *   - A zero-length (or absent) levels attribute — as produced by factor() —
 *     means levels are inferred from the data.
 *   - If @p to inherits from "ordered" the result is an ordered factor.
 *
 * Accepted source types and their behaviour:
 *   - character: values are matched against the levels directly.
 *   - integer:   values are formatted as decimal strings then matched.
 *   - factor:    level labels are extracted then matched against the new levels.
 *   - double:    values are formatted as strings (same as as.character()) then
 *               matched.
 *   - logical:   values are formatted as "TRUE"/"FALSE" then matched.
 *   - list:      each element is first reduced to a character scalar via
 *               stbl_lst_to_fct(), then matched against the levels.
 *
 * @param x   The vector to convert.
 * @param to  A factor used as a type template; only its levels attribute and
 *            class (ordered vs. unordered) are inspected — its values are
 *            ignored.
 * @return    A factor (or ordered factor) of the same length as @p x.
 * @note      Calls Rf_error() on conversion failure.  For richly formatted
 *            rlang errors call the R-level to() instead.
 */
SEXP to_factor(SEXP x, SEXP to) {
  int x_type = TYPEOF(x);

  /* Extract levels and ordered from `to`.
   * A zero-length levels attr (as produced by factor()) is treated as NULL
   * so that the underlying routines infer levels from the data. */
  SEXP to_levels_raw = Rf_getAttrib(to, R_LevelsSymbol);
  SEXP to_levels = (!Rf_isNull(to_levels_raw) && XLENGTH(to_levels_raw) == 0)
                     ? R_NilValue : to_levels_raw;
  SEXP ordered = PROTECT(Rf_ScalarLogical(Rf_inherits(to, "ordered")));

  SEXP res, chr, out;

  /* chr -> fct */
  if (x_type == STRSXP) {
    res = PROTECT(stbl_chr_to_fct(x, to_levels, ordered));
    out = check_valid(res, "factor");
    UNPROTECT(2); /* ordered, res */
    return out;
  }
  /* int -> fct */
  if (x_type == INTSXP && !Rf_inherits(x, "factor")) {
    res = PROTECT(stbl_int_to_fct(x, to_levels, ordered));
    out = check_valid(res, "factor");
    UNPROTECT(2);
    return out;
  }
  /* fct -> fct: convert to chr first, then to fct */
  if (x_type == INTSXP && Rf_inherits(x, "factor")) {
    chr = PROTECT(stbl_fct_to_chr(x));
    res = PROTECT(stbl_chr_to_fct(result_of(chr), to_levels, ordered));
    out = check_valid(res, "factor");
    UNPROTECT(3); /* ordered, chr, res */
    return out;
  }
  /* dbl -> fct: convert to chr first, then to fct */
  if (x_type == REALSXP) {
    chr = PROTECT(stbl_dbl_to_chr(x));
    res = PROTECT(stbl_chr_to_fct(result_of(chr), to_levels, ordered));
    out = check_valid(res, "factor");
    UNPROTECT(3);
    return out;
  }
  /* lgl -> fct: convert to chr first, then to fct */
  if (x_type == LGLSXP) {
    chr = PROTECT(stbl_lgl_to_chr(x));
    res = PROTECT(stbl_chr_to_fct(result_of(chr), to_levels, ordered));
    out = check_valid(res, "factor");
    UNPROTECT(3);
    return out;
  }
  /* lst -> fct: lst_to_fct produces a chr result, then chr_to_fct */
  if (x_type == VECSXP) {
    chr = PROTECT(stbl_lst_to_fct(x));
    out = check_valid(chr, "factor"); /* validates chr step */
    res = PROTECT(stbl_chr_to_fct(out, to_levels, ordered));
    out = check_valid(res, "factor");
    UNPROTECT(3); /* ordered, chr, res */
    return out;
  }
  UNPROTECT(1); /* ordered */
  Rf_error("Can't convert to <factor>.");
}
