#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>
#include <R_ext/Utils.h>
#include <ctype.h>

/* Valid R integer range.
 * NA_INTEGER == INT_MIN (-2147483648), so the representable range is
 * -2147483647 to 2147483647. */
#define STBL_INT_MAX  2147483647.0
#define STBL_INT_MIN -2147483647.0

/*
 * Core single-pass character-to-integer checker/converter.
 *
 * Fills p_result[0..n-1], p_non_number[0..n-1], p_bad_precision[0..n-1]:
 *   p_result:        the converted integer values (NA_INTEGER where conversion failed)
 *   p_non_number:    1 where the string is not parseable as a number (e.g. "a", "NaN")
 *   p_bad_precision: 1 where the string is numeric but not a valid integer
 *                    (e.g. "1.5", "Inf", out-of-range values)
 *
 * NA strings are passed through: result = NA_INTEGER, both flags = 0.
 */
static void chr_to_int_core(SEXP x, R_xlen_t n,
                             int* p_result,
                             int* p_non_number,
                             int* p_bad_precision) {
  for (R_xlen_t i = 0; i < n; i++) {
    SEXP xi = STRING_ELT(x, i);

    if (xi == NA_STRING) {
      p_result[i]        = NA_INTEGER;
      p_non_number[i]    = 0;
      p_bad_precision[i] = 0;
      continue;
    }

    const char* s = CHAR(xi);
    char* endptr;
    double dval = R_strtod(s, &endptr);

    /* endptr == s means no numeric characters were consumed at all */
    if (endptr == s) {
      p_result[i]        = NA_INTEGER;
      p_non_number[i]    = 1;
      p_bad_precision[i] = 0;
      continue;
    }

    /* Skip trailing whitespace: R's coercion accepts it.
       The loop is safe because s is null-terminated and '\0' is not whitespace,
       so the loop always terminates. */
    while (isspace((unsigned char)*endptr)) endptr++;

    if (*endptr != '\0' || ISNAN(dval)) {
      /* Trailing non-whitespace characters, or NaN (R treats NaN as NA) */
      p_result[i]        = NA_INTEGER;
      p_non_number[i]    = 1;
      p_bad_precision[i] = 0;
      continue;
    }

    /* Valid number — check if it is representable as an R integer */
    p_non_number[i] = 0;

    if (!R_FINITE(dval) || dval < STBL_INT_MIN || dval > STBL_INT_MAX) {
      /* Infinite, or outside R's integer range */
      p_result[i]        = NA_INTEGER;
      p_bad_precision[i] = 1;
      continue;
    }

    int ival = (int)dval;
    if ((double)ival != dval) {
      /* Fractional part — converting would lose precision */
      p_result[i]        = NA_INTEGER;
      p_bad_precision[i] = 1;
      continue;
    }

    p_result[i]        = ival;
    p_bad_precision[i] = 0;
  }
}

/*
 * ffi_chr_to_int: internal FFI entry point used by stbl itself.
 *
 * Returns a named list of three vectors of length(x):
 *   $result:        integer — the converted values (NA_integer_ where conversion failed)
 *   $non_number:    logical — TRUE for elements not parseable as a number
 *   $bad_precision: logical — TRUE for valid numbers that cannot be represented as integers
 */
SEXP ffi_chr_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP non_number    = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  chr_to_int_core(x, n, INTEGER(result), LOGICAL(non_number), LOGICAL(bad_precision));

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
 * stbl_chr_to_int: public API entry point.
 *
 * Returns an integer vector of length(x) with the converted values
 * (NA_integer_ where conversion failed).
 */
SEXP stbl_chr_to_int(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP non_number    = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  chr_to_int_core(x, n, INTEGER(result), LOGICAL(non_number), LOGICAL(bad_precision));
  UNPROTECT(3);
  return result;
}

/*
 * stbl_chr_are_intish: public API entry point.
 *
 * Returns a logical vector of length(x) that is TRUE for elements that can
 * be coerced to integer without loss, FALSE otherwise.
 */
SEXP stbl_chr_are_intish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result        = PROTECT(Rf_allocVector(INTSXP, n));
  SEXP non_number    = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP bad_precision = PROTECT(Rf_allocVector(LGLSXP, n));
  chr_to_int_core(x, n, INTEGER(result), LOGICAL(non_number), LOGICAL(bad_precision));

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
