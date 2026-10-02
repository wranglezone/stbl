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
 * Re-run the R-level to() on the original input so the failure is raised
 * from one place with the same classes, message, and fields as the R path.
 * `x_arg` and `call` may be R_NilValue to use to()'s defaults.  Normally
 * raises; if the R-level to() accepts an input the C fast paths could not
 * handle (for example raw -> character), its result is returned so both paths
 * agree.
 */
SEXP to_fail(SEXP x, SEXP to, SEXP x_arg, SEXP call);

/* Check the `valid` element (index 1) of a two-element result list. */
static inline SEXP check_valid(SEXP res, SEXP x, SEXP to, SEXP x_arg, SEXP call) {
  SEXP valid = VECTOR_ELT(res, 1);
  R_xlen_t n = XLENGTH(valid);
  int* p = LOGICAL(valid);
  for (R_xlen_t i = 0; i < n; i++) {
    if (!p[i]) return to_fail(x, to, x_arg, call);
  }
  return VECTOR_ELT(res, 0);
}

/* Check the `bad_precision` element (index 1) of a dbl-to-int result list. */
static inline SEXP check_precision(SEXP res, SEXP x, SEXP to, SEXP x_arg, SEXP call) {
  SEXP bad = VECTOR_ELT(res, 1);
  R_xlen_t n = XLENGTH(bad);
  int* p = LOGICAL(bad);
  for (R_xlen_t i = 0; i < n; i++) {
    if (p[i]) return to_fail(x, to, x_arg, call);
  }
  return VECTOR_ELT(res, 0);
}

/*
 * Check `non_number` (index 1) and `bad_precision` (index 2) of a
 * chr/fct-to-int result list.
 */
static inline SEXP check_int_cast(SEXP res, SEXP x, SEXP to, SEXP x_arg, SEXP call) {
  SEXP non_number    = VECTOR_ELT(res, 1);
  SEXP bad_precision = VECTOR_ELT(res, 2);
  R_xlen_t n = XLENGTH(non_number);
  int* p_nn = LOGICAL(non_number);
  int* p_bp = LOGICAL(bad_precision);
  for (R_xlen_t i = 0; i < n; i++) {
    if (p_nn[i] || p_bp[i]) return to_fail(x, to, x_arg, call);
  }
  return VECTOR_ELT(res, 0);
}

/* ── Per-target conversion helpers ───────────────────────────────────── */

SEXP to_logical(SEXP x, SEXP to, SEXP x_arg, SEXP call);
SEXP to_integer(SEXP x, SEXP to, SEXP x_arg, SEXP call);
SEXP to_double(SEXP x, SEXP to, SEXP x_arg, SEXP call);
SEXP to_character(SEXP x, SEXP to, SEXP x_arg, SEXP call);
SEXP to_factor(SEXP x, SEXP to, SEXP x_arg, SEXP call);

#endif /* TO_H */
