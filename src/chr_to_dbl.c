#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>
#include <R_ext/Utils.h>
#include <ctype.h>

/*
 * Core single-pass character-to-double checker/converter.
 *
 * Fills p_result[0..n-1] and p_valid[0..n-1]:
 *   p_result: the converted double values (NA_REAL where conversion failed)
 *   p_valid:  1 for elements that converted successfully, 0 otherwise
 *
 * Recognises any string parseable as a finite or infinite double via R_strtod.
 * NaN is rejected: R treats NaN as NA (is.na(NaN) == TRUE), so "NaN" is not
 * a valid double for coercion purposes.  NA strings pass through as NA_REAL.
 */
static void chr_to_dbl_core(SEXP x, R_xlen_t n, double* p_result, int* p_valid) {
  for (R_xlen_t i = 0; i < n; i++) {
    SEXP xi = STRING_ELT(x, i);

    if (xi == NA_STRING) {
      p_result[i] = NA_REAL;
      p_valid[i]  = 1;
      continue;
    }

    const char* s = CHAR(xi);
    char* endptr;
    double dval = R_strtod(s, &endptr);

    /* endptr == s means no numeric characters were consumed at all */
    if (endptr == s) {
      p_result[i] = NA_REAL;
      p_valid[i]  = 0;
      continue;
    }

    /* Skip trailing whitespace: R's coercion accepts it.
       The loop is safe because s is null-terminated and '\0' is not whitespace,
       so the loop always terminates. */
    while (isspace((unsigned char)*endptr)) endptr++;

    if (*endptr != '\0' || ISNAN(dval)) {
      /* Trailing non-whitespace characters, or NaN (R treats NaN as NA) */
      p_result[i] = NA_REAL;
      p_valid[i]  = 0;
      continue;
    }

    p_result[i] = dval;
    p_valid[i]  = 1;
  }
}

/*
 * ffi_chr_to_dbl: internal FFI entry point used by stbl itself.
 *
 * Returns a named list of two vectors of length(x):
 *   $result: double — the converted values (NA_real_ where conversion failed)
 *   $valid:  logical — TRUE for elements that converted successfully
 */
SEXP ffi_chr_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  chr_to_dbl_core(x, n, REAL(result), LOGICAL(valid));

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SET_VECTOR_ELT(out, 0, result);
  SET_VECTOR_ELT(out, 1, valid);
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_STRING_ELT(names, 0, Rf_mkChar("result"));
  SET_STRING_ELT(names, 1, Rf_mkChar("valid"));
  Rf_setAttrib(out, R_NamesSymbol, names);
  UNPROTECT(4);
  return out;
}

/*
 * stbl_chr_to_dbl: public API entry point.
 *
 * Returns a double vector of length(x) with the converted values
 * (NA_real_ where conversion failed).
 */
SEXP stbl_chr_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  chr_to_dbl_core(x, n, REAL(result), LOGICAL(valid));
  UNPROTECT(2);
  return result;
}

/*
 * stbl_chr_are_dblish: public API entry point.
 *
 * Returns a logical vector of length(x) that is TRUE for elements that can
 * be coerced to double, FALSE otherwise.
 */
SEXP stbl_chr_are_dblish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  chr_to_dbl_core(x, n, REAL(result), LOGICAL(valid));
  UNPROTECT(2);
  return valid;
}
