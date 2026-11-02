#ifndef STBL_NAMES_H
#define STBL_NAMES_H

#include <R.h>
#include <Rinternals.h>

/*
 * Copy the names of `from` (if any) onto `to`, so conversions keep the names
 * of the incoming vector. `to` must be PROTECTed by the caller.
 */
static inline void copy_names(SEXP from, SEXP to) {
  SEXP nms = Rf_getAttrib(from, R_NamesSymbol);
  if (nms != R_NilValue) {
    Rf_setAttrib(to, R_NamesSymbol, nms);
  }
}

#endif /* STBL_NAMES_H */
