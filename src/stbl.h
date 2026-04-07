#ifndef STBL_H
#define STBL_H

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>
#include <R_ext/Utils.h>
#include <ctype.h>
#include <math.h>

/* Valid R integer range.
 * NA_INTEGER == INT_MIN (-2147483648), so the representable range is
 * -2147483647 to 2147483647. */
#define STBL_INT_MAX  2147483647.0
#define STBL_INT_MIN -2147483647.0

/*
 * Core single-pass character-to-double checker/converter.
 *
 * Fills p_result[0..n-1] and p_valid[0..n-1]:
 *   p_result: the converted double values (NA_REAL where conversion failed)
 *   p_valid:  1 for elements that converted successfully, 0 otherwise
 *
 * NA strings pass through as NA_REAL (valid). NaN is rejected.
 */
static inline void stbl_chr_to_dbl_core(SEXP x, R_xlen_t n,
                                         double* p_result, int* p_valid) {
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

    if (endptr == s) {
      p_result[i] = NA_REAL;
      p_valid[i]  = 0;
      continue;
    }

    while (isspace((unsigned char)*endptr)) endptr++;

    if (*endptr != '\0' || ISNAN(dval)) {
      p_result[i] = NA_REAL;
      p_valid[i]  = 0;
      continue;
    }

    p_result[i] = dval;
    p_valid[i]  = 1;
  }
}

/*
 * Core single-pass character-to-integer checker/converter.
 *
 * Fills p_result[0..n-1], p_non_number[0..n-1], p_bad_precision[0..n-1].
 * NA strings pass through as NA_INTEGER (both flags 0).
 */
static inline void stbl_chr_to_int_core(SEXP x, R_xlen_t n,
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

    if (endptr == s) {
      p_result[i]        = NA_INTEGER;
      p_non_number[i]    = 1;
      p_bad_precision[i] = 0;
      continue;
    }

    while (isspace((unsigned char)*endptr)) endptr++;

    if (*endptr != '\0' || ISNAN(dval)) {
      p_result[i]        = NA_INTEGER;
      p_non_number[i]    = 1;
      p_bad_precision[i] = 0;
      continue;
    }

    p_non_number[i] = 0;

    if (!R_FINITE(dval) || dval < STBL_INT_MIN || dval > STBL_INT_MAX) {
      p_result[i]        = NA_INTEGER;
      p_bad_precision[i] = 1;
      continue;
    }

    int ival = (int)dval;
    if ((double)ival != dval) {
      p_result[i]        = NA_INTEGER;
      p_bad_precision[i] = 1;
      continue;
    }

    p_result[i]        = ival;
    p_bad_precision[i] = 0;
  }
}

/* Case-insensitive check for "T" or "TRUE" */
static inline int stbl_is_true_str(const char* s) {
  if ((s[0] == 'T' || s[0] == 't') && s[1] == '\0') return 1;
  if ((s[0] == 'T' || s[0] == 't') &&
      (s[1] == 'R' || s[1] == 'r') &&
      (s[2] == 'U' || s[2] == 'u') &&
      (s[3] == 'E' || s[3] == 'e') &&
      s[4] == '\0') return 1;
  return 0;
}

/* Case-insensitive check for "F" or "FALSE" */
static inline int stbl_is_false_str(const char* s) {
  if ((s[0] == 'F' || s[0] == 'f') && s[1] == '\0') return 1;
  if ((s[0] == 'F' || s[0] == 'f') &&
      (s[1] == 'A' || s[1] == 'a') &&
      (s[2] == 'L' || s[2] == 'l') &&
      (s[3] == 'S' || s[3] == 's') &&
      (s[4] == 'E' || s[4] == 'e') &&
      s[5] == '\0') return 1;
  return 0;
}

/*
 * Core single-pass character-to-logical checker/converter.
 *
 * Fills p_result[0..n-1] and p_valid[0..n-1].
 * NA strings pass through as NA_LOGICAL (valid).
 */
static inline void stbl_chr_to_lgl_core(SEXP x, R_xlen_t n,
                                         int* p_result, int* p_valid) {
  for (R_xlen_t i = 0; i < n; i++) {
    SEXP xi = STRING_ELT(x, i);

    if (xi == NA_STRING) {
      p_result[i] = NA_LOGICAL;
      p_valid[i]  = 1;
      continue;
    }

    const char* s = CHAR(xi);

    if (stbl_is_true_str(s)) {
      p_result[i] = 1;
      p_valid[i]  = 1;
      continue;
    }

    if (stbl_is_false_str(s)) {
      p_result[i] = 0;
      p_valid[i]  = 1;
      continue;
    }

    char* endptr;
    double dval = R_strtod(s, &endptr);
    if (endptr == s) {
      p_result[i] = NA_LOGICAL;
      p_valid[i]  = 0;
      continue;
    }
    while (isspace((unsigned char)*endptr)) endptr++;
    if (*endptr == '\0' && !ISNAN(dval)) {
      p_result[i] = (dval != 0.0) ? 1 : 0;
      p_valid[i]  = 1;
    } else {
      p_result[i] = NA_LOGICAL;
      p_valid[i]  = 0;
    }
  }
}

#endif /* STBL_H */
