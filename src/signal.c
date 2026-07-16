#include <R.h>
#include <Rinternals.h>

/*
 * Build and signal a classed error condition from C so that R-side
 * tryCatch()/try_fetch() handlers can catch it by class name.  Returns the
 * SEXP result of stop(), which always unwinds the R stack; the SEXP return
 * type lets callers write "return signal_classed_error(...)" to satisfy
 * non-void return requirements without any unreachable fallback.
 */
SEXP signal_classed_error(const char* cls0) {
  SEXP nms = PROTECT(Rf_allocVector(STRSXP, 1));
  SET_STRING_ELT(nms, 0, Rf_mkChar("message"));

  SEXP cond = PROTECT(Rf_allocVector(VECSXP, 1));
  SET_VECTOR_ELT(cond, 0, Rf_mkString(cls0)); /* message = class name */
  Rf_setAttrib(cond, R_NamesSymbol, nms);

  SEXP cls = PROTECT(Rf_allocVector(STRSXP, 3));
  SET_STRING_ELT(cls, 0, Rf_mkChar(cls0));
  SET_STRING_ELT(cls, 1, Rf_mkChar("error"));
  SET_STRING_ELT(cls, 2, Rf_mkChar("condition"));
  Rf_setAttrib(cond, R_ClassSymbol, cls);

  return Rf_eval(Rf_lang2(Rf_install("stop"), cond), R_BaseEnv);
}
