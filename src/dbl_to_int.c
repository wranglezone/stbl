#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>
#include <math.h>

/* Valid R integer range.
 * NA_INTEGER == INT_MIN (-2147483648), so the representable range is
 * -2147483647 to 2147483647. */
#define STBL_INT_MAX  2147483647.0
#define STBL_INT_MIN -2147483647.0

/*
 * Core single-pass double-to-integer checker/converter.
 *
 * Fills p_result[0..n-1] and p_bad_precision[0..n-1]:
 *   p_result:        the converted integer values (NA_INTEGER where conversion failed)
 *   p_bad_precision: 1 where the value is not representable as an R integer
 *                    (Inf, -Inf, fractional, or out-of-range)
 *
 * NA and NaN are passed through: result = NA_INTEGER, bad_precision = 0.
 * R treats NaN as NA (is.na(NaN) == TRUE), so both are valid NA pass-throughs.
 */
static void dbl_to_int_core(SEXP x, R_xlen_t n,
                             int* p_result,
                             int* p_bad_precision) {
  double* px = REAL(x);
  for (R_xlen_t i = 0; i < n; i++) {
    double v = px[i];

    if (ISNAN(v)) {
      /* NA or NaN -> NA_integer_, not a precision error */
      p_result[i]        = NA_INTEGER;
      p_bad_precision[i] = 0;
      continue;
    }

    if (!R_FINITE(v) || v < STBL_INT_MIN || v > STBL_INT_MAX || v != floor(v)) {
      /* Infinite, out-of-range, or fractional */
      p_result[i]        = NA_INTEGER;
      p_bad_precision[i] = 1;
      continue;
    }

    p_result[i]        = (int)v;
    p_bad_precision[i] = 0;
  }
}

/*
 * ffi_dbl_to_int: internal FFI entry point used by stbl itself.
 *
 * Returns a named list of two vectors of length(x):
 *   $result:        integer — the converted values (NA_integer_ where conversion failed)
 *   $bad_precision: logical — TRUE for values that cannot be represented as integers
 */
SEXP ffi_dbl_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  dbl_to_int_core(x, n, INTEGER(result), LOGICAL(bad_precision));

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SET_VECTOR_ELT(out, 0, result);
  SET_VECTOR_ELT(out, 1, bad_precision);
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_STRING_ELT(names, 0, Rf_mkChar("result"));
  SET_STRING_ELT(names, 1, Rf_mkChar("bad_precision"));
  Rf_setAttrib(out, R_NamesSymbol, names);
  UNPROTECT(4);
  return out;
}

/*
 * stbl_dbl_to_int: public API entry point.
 *
 * Returns an integer vector of length(x) with the converted values
 * (NA_integer_ where conversion failed).
 */
SEXP stbl_dbl_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  dbl_to_int_core(x, n, INTEGER(result), LOGICAL(bad_precision));
  UNPROTECT(2);
  return result;
}

/*
 * stbl_dbl_are_intish: public API entry point.
 *
 * Returns a logical vector of length(x) that is TRUE for elements that can
 * be coerced to integer without loss (including NA/NaN), FALSE otherwise.
 */
SEXP stbl_dbl_are_intish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  dbl_to_int_core(x, n, INTEGER(result), LOGICAL(bad_precision));

  SEXP valid = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_bad = LOGICAL(bad_precision);
  int* p_val = LOGICAL(valid);
  for (R_xlen_t i = 0; i < n; i++) {
    p_val[i] = !p_bad[i];
  }
  UNPROTECT(3);
  return valid;
}
