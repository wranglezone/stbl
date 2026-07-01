#ifndef TO_H
#define TO_H

#include "stbl.h"

/* ── Check helpers ────────────────────────────────────────────────────── */

/*
 * Extract the `result` element (index 0) from the list returned by all
 * stbl_*_to_*() functions.
 */
static inline SEXP result_of(SEXP res) {
  return VECTOR_ELT(res, 0);
}

/*
 * Check the `valid` element (index 1) of a two-element result list.
 * Calls Rf_error() if any element is FALSE.
 */
static inline SEXP check_valid(SEXP res, const char* to_class) {
  SEXP valid = VECTOR_ELT(res, 1);
  R_xlen_t n = XLENGTH(valid);
  int* p = LOGICAL(valid);
  for (R_xlen_t i = 0; i < n; i++) {
    if (!p[i]) Rf_error("Can't convert to <%s>.", to_class);
  }
  return VECTOR_ELT(res, 0);
}

/*
 * Check the `bad_precision` element (index 1) of a dbl-to-int result list.
 * Calls Rf_error() if any element is TRUE.
 */
static inline SEXP check_precision(SEXP res, const char* from_class) {
  SEXP bad = VECTOR_ELT(res, 1);
  R_xlen_t n = XLENGTH(bad);
  int* p = LOGICAL(bad);
  for (R_xlen_t i = 0; i < n; i++) {
    if (p[i]) {
      Rf_error(
        "Can't convert <%s> to <integer> due to loss of precision.",
        from_class
      );
    }
  }
  return VECTOR_ELT(res, 0);
}

/*
 * Check `non_number` (index 1) and `bad_precision` (index 2) of a
 * chr/fct-to-int result list.  Calls Rf_error() on the first failure.
 */
static inline SEXP check_int_cast(SEXP res, const char* from_class) {
  SEXP non_number    = VECTOR_ELT(res, 1);
  SEXP bad_precision = VECTOR_ELT(res, 2);
  R_xlen_t n = XLENGTH(non_number);
  int* p_nn = LOGICAL(non_number);
  int* p_bp = LOGICAL(bad_precision);
  for (R_xlen_t i = 0; i < n; i++) {
    if (p_nn[i]) {
      Rf_error(
        "Can't convert <%s> to <integer>: incompatible values.",
        from_class
      );
    }
    if (p_bp[i]) {
      Rf_error(
        "Can't convert <%s> to <integer> due to loss of precision.",
        from_class
      );
    }
  }
  return VECTOR_ELT(res, 0);
}

/* ── Per-target conversion helpers ───────────────────────────────────── */

SEXP to_logical(SEXP x);
SEXP to_integer(SEXP x);
SEXP to_double(SEXP x);
SEXP to_character(SEXP x);
SEXP to_factor(SEXP x, SEXP to);

#endif /* TO_H */
