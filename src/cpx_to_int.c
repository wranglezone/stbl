#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>
#include <R_ext/Complex.h>
#include <math.h>

/* Valid R integer range */
#define STBL_INT_MAX  2147483647.0
#define STBL_INT_MIN -2147483647.0

/*
 * Core single-pass complex-to-integer checker/converter.
 *
 * A complex value is int-ish iff it is NA, or its imaginary part is zero and
 * its real part is a whole number within R's integer range.
 *
 * Fills p_result[0..n-1], p_non_number[0..n-1], p_bad_precision[0..n-1]:
 *   p_result:        the converted integer values (NA_INTEGER where failed)
 *   p_non_number:    1 where Im != 0 (complex component is non-zero)
 *   p_bad_precision: 1 where Im == 0 but Re is not int-representable
 *
 * NA_complex_ (either part NaN) passes through: result = NA_INTEGER, both = 0.
 */
static void cpx_to_int_core(SEXP x, R_xlen_t n,
                              int* p_result,
                              int* p_non_number,
                              int* p_bad_precision) {
  Rcomplex* px = COMPLEX(x);
  for (R_xlen_t i = 0; i < n; i++) {
    double r  = px[i].r;
    double im = px[i].i;

    if (ISNAN(r) || ISNAN(im)) {
      /* NA complex -> pass through as NA_INTEGER */
      p_result[i]        = NA_INTEGER;
      p_non_number[i]    = 0;
      p_bad_precision[i] = 0;
      continue;
    }

    if (im != 0.0) {
      /* Non-zero imaginary part */
      p_result[i]        = NA_INTEGER;
      p_non_number[i]    = 1;
      p_bad_precision[i] = 0;
      continue;
    }

    /* Im == 0: check if Re is integer-representable */
    p_non_number[i] = 0;

    if (!R_FINITE(r) || r < STBL_INT_MIN || r > STBL_INT_MAX) {
      p_result[i]        = NA_INTEGER;
      p_bad_precision[i] = 1;
      continue;
    }

    int ival = (int)r;
    if ((double)ival != r) {
      p_result[i]        = NA_INTEGER;
      p_bad_precision[i] = 1;
      continue;
    }

    p_result[i]        = ival;
    p_bad_precision[i] = 0;
  }
}

/*
 * ffi_cpx_to_int: internal FFI entry point used by stbl itself.
 *
 * Returns a named list of three vectors of length(x):
 *   $result:        integer — converted values (NA_integer_ where failed)
 *   $non_number:    logical — TRUE for elements with Im != 0
 *   $bad_precision: logical — TRUE for elements where Im==0 but Re is not int-ish
 */
SEXP ffi_cpx_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP non_number    = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  cpx_to_int_core(x, n, INTEGER(result), LOGICAL(non_number),
                  LOGICAL(bad_precision));

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 3));
  SET_VECTOR_ELT(out, 0, result);
  SET_VECTOR_ELT(out, 1, non_number);
  SET_VECTOR_ELT(out, 2, bad_precision);
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 3));
  SET_STRING_ELT(names, 0, Rf_mkChar("result"));
  SET_STRING_ELT(names, 1, Rf_mkChar("non_number"));
  SET_STRING_ELT(names, 2, Rf_mkChar("bad_precision"));
  Rf_setAttrib(out, R_NamesSymbol, names);
  UNPROTECT(5);
  return out;
}

/*
 * stbl_cpx_to_int: public API entry point.
 *
 * Returns an integer vector of length(x) (NA_integer_ where conversion
 * failed).
 */
SEXP stbl_cpx_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP non_number    = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  cpx_to_int_core(x, n, INTEGER(result), LOGICAL(non_number),
                  LOGICAL(bad_precision));
  UNPROTECT(3);
  return result;
}

/*
 * stbl_cpx_are_intish: public API entry point.
 *
 * Returns a logical vector of length(x) that is TRUE for elements that can
 * be coerced to integer (NA, or Im==0 and Re is a whole number in range).
 */
SEXP stbl_cpx_are_intish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP non_number    = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  cpx_to_int_core(x, n, INTEGER(result), LOGICAL(non_number),
                  LOGICAL(bad_precision));

  SEXP valid = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_non = LOGICAL(non_number);
  int* p_bad = LOGICAL(bad_precision);
  int* p_val = LOGICAL(valid);
  for (R_xlen_t i = 0; i < n; i++) {
    p_val[i] = !p_non[i] && !p_bad[i];
  }
  UNPROTECT(4);
  return valid;
}
