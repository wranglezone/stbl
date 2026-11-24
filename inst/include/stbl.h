#ifndef STBL_API_H
#define STBL_API_H

#include <Rinternals.h>
#include <R_ext/Rdynload.h>

/* chr -> * */
extern SEXP (*stbl_chr_to_lgl)(SEXP);
extern SEXP (*stbl_chr_are_lglish)(SEXP);
extern SEXP (*stbl_chr_to_int)(SEXP);
extern SEXP (*stbl_chr_are_intish)(SEXP);
extern SEXP (*stbl_chr_to_dbl)(SEXP);
extern SEXP (*stbl_chr_are_dblish)(SEXP);
extern SEXP (*stbl_chr_are_fctish)(SEXP, SEXP, SEXP);
extern SEXP (*stbl_chr_to_fct)(SEXP, SEXP, SEXP);

/* dbl -> * */
extern SEXP (*stbl_dbl_to_int)(SEXP);
extern SEXP (*stbl_dbl_are_intish)(SEXP);
extern SEXP (*stbl_dbl_to_lgl)(SEXP);
extern SEXP (*stbl_dbl_are_lglish)(SEXP);
extern SEXP (*stbl_dbl_to_chr)(SEXP);
extern SEXP (*stbl_dbl_are_chrish)(SEXP);

/* int -> * */
extern SEXP (*stbl_int_to_dbl)(SEXP);
extern SEXP (*stbl_int_are_dblish)(SEXP);
extern SEXP (*stbl_int_to_chr)(SEXP);
extern SEXP (*stbl_int_are_chrish)(SEXP);
extern SEXP (*stbl_int_to_fct)(SEXP, SEXP, SEXP);

/* lgl -> * */
extern SEXP (*stbl_lgl_to_dbl)(SEXP);
extern SEXP (*stbl_lgl_are_dblish)(SEXP);
extern SEXP (*stbl_lgl_to_int)(SEXP);
extern SEXP (*stbl_lgl_are_intish)(SEXP);
extern SEXP (*stbl_lgl_to_chr)(SEXP);
extern SEXP (*stbl_lgl_are_chrish)(SEXP);

/* cpx -> * */
extern SEXP (*stbl_cpx_to_dbl)(SEXP);
extern SEXP (*stbl_cpx_are_dblish)(SEXP);
extern SEXP (*stbl_cpx_to_int)(SEXP);
extern SEXP (*stbl_cpx_are_intish)(SEXP);

/* fct -> * */
extern SEXP (*stbl_fct_to_dbl)(SEXP);
extern SEXP (*stbl_fct_are_dblish)(SEXP);
extern SEXP (*stbl_fct_to_int)(SEXP);
extern SEXP (*stbl_fct_are_intish)(SEXP);
extern SEXP (*stbl_fct_to_lgl)(SEXP);
extern SEXP (*stbl_fct_are_lglish)(SEXP);
extern SEXP (*stbl_fct_are_fctish)(SEXP, SEXP, SEXP);
extern SEXP (*stbl_fct_to_chr)(SEXP);
extern SEXP (*stbl_fct_are_chrish)(SEXP);

/* lst -> * */
extern SEXP (*stbl_lst_to_dbl)(SEXP);
extern SEXP (*stbl_lst_to_int)(SEXP);
extern SEXP (*stbl_lst_to_lgl)(SEXP);
extern SEXP (*stbl_lst_to_chr)(SEXP);
extern SEXP (*stbl_lst_to_fct)(SEXP);

/* range checks */
extern SEXP (*stbl_check_min_dbl)(SEXP, SEXP);
extern SEXP (*stbl_check_max_dbl)(SEXP, SEXP);
extern SEXP (*stbl_check_min_dbl_exclusive)(SEXP, SEXP);
extern SEXP (*stbl_check_max_dbl_exclusive)(SEXP, SEXP);

/* reconcile
 *
 * stbl_reconcile(values) checks that every value in `values` (a list of at
 * least one value) is equivalent to every other value, as described in the R
 * documentation of reconcile(). It returns a list with two elements, `result`
 * and `mismatch`.
 *
 * When the values are equivalent, `result` is their narrowest common
 * representation and `mismatch` is NULL. Otherwise `result` is NULL and
 * `mismatch` is list(i, j, at, reason):
 *   - `i` and `j` (integer(1)): the 1-based positions in `values` of the first
 *     pair that are not equivalent.
 *   - `at` (integer): the 1-based positions, from the top, that lead to the
 *     first difference inside lists and data frames, following `values[[1]]`.
 *     It is integer(0) when the values differ at the top level.
 *   - `reason` (integer(1)): one of the STBL_RECONCILE_* codes below.
 * The caller raises the error, as with the conversion routines. The routine
 * itself only raises an error if `values` is not a non-empty list.
 */
#define STBL_RECONCILE_NO_REASON    0 /* No more specific reason. */
#define STBL_RECONCILE_LENGTHS      1
#define STBL_RECONCILE_NAMES        2
#define STBL_RECONCILE_ORDERING     3 /* Factor vs ordered factor. */
#define STBL_RECONCILE_LEVELS       4
#define STBL_RECONCILE_TIME_ZONES   5
#define STBL_RECONCILE_CLASSES      6 /* Data frame classes. */
#define STBL_RECONCILE_COLUMN_NAMES 7
#define STBL_RECONCILE_ROW_NAMES    8
#define STBL_RECONCILE_ATTRIBUTES   9

extern SEXP (*stbl_reconcile)(SEXP);

/* to
 *
 * stbl_to(x, to, x_arg, to_arg, call) converts `x` to the type of `to`. Unclassed logical,
 * integer, double, and character targets (and factor targets) use fast C
 * conversion routines; all other targets (Date, POSIXct, hms, Period, list,
 * and other classed prototypes) are delegated to the R-level stbl::to(),
 * which falls back to vctrs::vec_cast() for classes stbl does not handle.
 * `x_arg` and `to_arg` (strings) and `call` (a call or environment) supply
 * error context, and `to_arg` names the target in messages;
 * pass R_NilValue for any of them to use the defaults. Failures raise the same
 * classed rlang errors as the R-level to().
 */
extern SEXP (*stbl_to)(SEXP, SEXP, SEXP, SEXP, SEXP);

void stbl_init_api(void);

#endif /* STBL_API_H */
