#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

SEXP stbl_lgl_from_chr(SEXP x);

static const R_CallMethodDef callMethods[] = {
  {"stbl_lgl_from_chr", (DL_FUNC) &stbl_lgl_from_chr, 1},
  {NULL, NULL, 0}
};

void R_init_stbl(DllInfo* dll) {
  R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
