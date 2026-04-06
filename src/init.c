#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

SEXP ffi_chr_to_lgl(SEXP x);
SEXP stbl_chr_to_lgl(SEXP x);
SEXP stbl_chr_are_lglish(SEXP x);

SEXP ffi_chr_to_int(SEXP x);
SEXP stbl_chr_to_int(SEXP x);
SEXP stbl_chr_are_intish(SEXP x);

SEXP ffi_chr_to_dbl(SEXP x);
SEXP stbl_chr_to_dbl(SEXP x);
SEXP stbl_chr_are_dblish(SEXP x);

static const R_CallMethodDef callMethods[] = {
  {"ffi_chr_to_lgl",      (DL_FUNC) &ffi_chr_to_lgl,      1},
  {"stbl_chr_to_lgl",     (DL_FUNC) &stbl_chr_to_lgl,     1},
  {"stbl_chr_are_lglish", (DL_FUNC) &stbl_chr_are_lglish,  1},
  {"ffi_chr_to_int",      (DL_FUNC) &ffi_chr_to_int,      1},
  {"stbl_chr_to_int",     (DL_FUNC) &stbl_chr_to_int,     1},
  {"stbl_chr_are_intish", (DL_FUNC) &stbl_chr_are_intish,  1},
  {"ffi_chr_to_dbl",      (DL_FUNC) &ffi_chr_to_dbl,      1},
  {"stbl_chr_to_dbl",     (DL_FUNC) &stbl_chr_to_dbl,     1},
  {"stbl_chr_are_dblish", (DL_FUNC) &stbl_chr_are_dblish,  1},
  {NULL, NULL, 0}
};

void R_init_stbl(DllInfo* dll) {
  R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
