#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

SEXP ffi_chr_to_lgl(SEXP x);
SEXP stbl_chr_to_lgl(SEXP x);
SEXP stbl_chr_are_lglish(SEXP x);

static const R_CallMethodDef callMethods[] = {
  {"ffi_chr_to_lgl",     (DL_FUNC) &ffi_chr_to_lgl,     1},
  {"stbl_chr_to_lgl",    (DL_FUNC) &stbl_chr_to_lgl,    1},
  {"stbl_chr_are_lglish",(DL_FUNC) &stbl_chr_are_lglish, 1},
  {NULL, NULL, 0}
};

void R_init_stbl(DllInfo* dll) {
  R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
