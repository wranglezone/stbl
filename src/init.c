#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

/* chr -> * */
SEXP ffi_chr_to_lgl(SEXP x);
SEXP stbl_chr_to_lgl(SEXP x);
SEXP stbl_chr_are_lglish(SEXP x);

SEXP ffi_chr_to_int(SEXP x);
SEXP stbl_chr_to_int(SEXP x);
SEXP stbl_chr_are_intish(SEXP x);

SEXP ffi_chr_to_dbl(SEXP x);
SEXP stbl_chr_to_dbl(SEXP x);
SEXP stbl_chr_are_dblish(SEXP x);

SEXP stbl_chr_are_fctish(SEXP x, SEXP levels, SEXP to_na);

/* dbl -> * */
SEXP ffi_dbl_to_int(SEXP x);
SEXP stbl_dbl_to_int(SEXP x);
SEXP stbl_dbl_are_intish(SEXP x);

SEXP stbl_dbl_to_lgl(SEXP x);
SEXP stbl_dbl_are_lglish(SEXP x);

/* int -> * */
SEXP stbl_int_to_dbl(SEXP x);
SEXP stbl_int_are_dblish(SEXP x);

/* lgl -> * */
SEXP stbl_lgl_to_dbl(SEXP x);
SEXP stbl_lgl_are_dblish(SEXP x);

SEXP stbl_lgl_to_int(SEXP x);
SEXP stbl_lgl_are_intish(SEXP x);

/* cpx -> * */
SEXP ffi_cpx_to_dbl(SEXP x);
SEXP stbl_cpx_to_dbl(SEXP x);
SEXP stbl_cpx_are_dblish(SEXP x);

SEXP ffi_cpx_to_int(SEXP x);
SEXP stbl_cpx_to_int(SEXP x);
SEXP stbl_cpx_are_intish(SEXP x);

/* fct -> * */
SEXP ffi_fct_to_dbl(SEXP x);
SEXP stbl_fct_to_dbl(SEXP x);
SEXP stbl_fct_are_dblish(SEXP x);

SEXP ffi_fct_to_int(SEXP x);
SEXP stbl_fct_to_int(SEXP x);
SEXP stbl_fct_are_intish(SEXP x);

SEXP ffi_fct_to_lgl(SEXP x);
SEXP stbl_fct_to_lgl(SEXP x);
SEXP stbl_fct_are_lglish(SEXP x);

SEXP stbl_fct_are_fctish(SEXP x, SEXP levels, SEXP to_na);

/* lst -> * */
SEXP stbl_lst_to_dbl(SEXP x);
SEXP stbl_lst_to_int(SEXP x);
SEXP stbl_lst_to_lgl(SEXP x);
SEXP stbl_lst_to_chr(SEXP x);
SEXP stbl_lst_to_fct(SEXP x);

static const R_CallMethodDef callMethods[] = {
  /* chr -> * */
  {"ffi_chr_to_lgl",       (DL_FUNC) &ffi_chr_to_lgl,       1},
  {"stbl_chr_to_lgl",      (DL_FUNC) &stbl_chr_to_lgl,      1},
  {"stbl_chr_are_lglish",  (DL_FUNC) &stbl_chr_are_lglish,  1},
  {"ffi_chr_to_int",       (DL_FUNC) &ffi_chr_to_int,       1},
  {"stbl_chr_to_int",      (DL_FUNC) &stbl_chr_to_int,      1},
  {"stbl_chr_are_intish",  (DL_FUNC) &stbl_chr_are_intish,  1},
  {"ffi_chr_to_dbl",       (DL_FUNC) &ffi_chr_to_dbl,       1},
  {"stbl_chr_to_dbl",      (DL_FUNC) &stbl_chr_to_dbl,      1},
  {"stbl_chr_are_dblish",  (DL_FUNC) &stbl_chr_are_dblish,  1},
  {"stbl_chr_are_fctish",  (DL_FUNC) &stbl_chr_are_fctish,  3},
  /* dbl -> * */
  {"ffi_dbl_to_int",       (DL_FUNC) &ffi_dbl_to_int,       1},
  {"stbl_dbl_to_int",      (DL_FUNC) &stbl_dbl_to_int,      1},
  {"stbl_dbl_are_intish",  (DL_FUNC) &stbl_dbl_are_intish,  1},
  {"stbl_dbl_to_lgl",      (DL_FUNC) &stbl_dbl_to_lgl,      1},
  {"stbl_dbl_are_lglish",  (DL_FUNC) &stbl_dbl_are_lglish,  1},
  /* int -> * */
  {"stbl_int_to_dbl",      (DL_FUNC) &stbl_int_to_dbl,      1},
  {"stbl_int_are_dblish",  (DL_FUNC) &stbl_int_are_dblish,  1},
  /* lgl -> * */
  {"stbl_lgl_to_dbl",      (DL_FUNC) &stbl_lgl_to_dbl,      1},
  {"stbl_lgl_are_dblish",  (DL_FUNC) &stbl_lgl_are_dblish,  1},
  {"stbl_lgl_to_int",      (DL_FUNC) &stbl_lgl_to_int,      1},
  {"stbl_lgl_are_intish",  (DL_FUNC) &stbl_lgl_are_intish,  1},
  /* cpx -> * */
  {"ffi_cpx_to_dbl",       (DL_FUNC) &ffi_cpx_to_dbl,       1},
  {"stbl_cpx_to_dbl",      (DL_FUNC) &stbl_cpx_to_dbl,      1},
  {"stbl_cpx_are_dblish",  (DL_FUNC) &stbl_cpx_are_dblish,  1},
  {"ffi_cpx_to_int",       (DL_FUNC) &ffi_cpx_to_int,       1},
  {"stbl_cpx_to_int",      (DL_FUNC) &stbl_cpx_to_int,      1},
  {"stbl_cpx_are_intish",  (DL_FUNC) &stbl_cpx_are_intish,  1},
  /* fct -> * */
  {"ffi_fct_to_dbl",       (DL_FUNC) &ffi_fct_to_dbl,       1},
  {"stbl_fct_to_dbl",      (DL_FUNC) &stbl_fct_to_dbl,      1},
  {"stbl_fct_are_dblish",  (DL_FUNC) &stbl_fct_are_dblish,  1},
  {"ffi_fct_to_int",       (DL_FUNC) &ffi_fct_to_int,       1},
  {"stbl_fct_to_int",      (DL_FUNC) &stbl_fct_to_int,      1},
  {"stbl_fct_are_intish",  (DL_FUNC) &stbl_fct_are_intish,  1},
  {"ffi_fct_to_lgl",       (DL_FUNC) &ffi_fct_to_lgl,       1},
  {"stbl_fct_to_lgl",      (DL_FUNC) &stbl_fct_to_lgl,      1},
  {"stbl_fct_are_lglish",  (DL_FUNC) &stbl_fct_are_lglish,  1},
  {"stbl_fct_are_fctish",  (DL_FUNC) &stbl_fct_are_fctish,  3},
  /* lst -> * */
  {"stbl_lst_to_dbl",      (DL_FUNC) &stbl_lst_to_dbl,      1},
  {"stbl_lst_to_int",      (DL_FUNC) &stbl_lst_to_int,      1},
  {"stbl_lst_to_lgl",      (DL_FUNC) &stbl_lst_to_lgl,      1},
  {"stbl_lst_to_chr",      (DL_FUNC) &stbl_lst_to_chr,      1},
  {"stbl_lst_to_fct",      (DL_FUNC) &stbl_lst_to_fct,      1},
  {NULL, NULL, 0}
};

void R_init_stbl(DllInfo* dll) {
  R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
