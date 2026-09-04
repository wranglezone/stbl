#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>

/*
 * Scan a REALSXP or INTSXP vector for values below (type=0) or above
 * (type=1) the threshold. When strict is 1, the boundary itself also fails
 * (exclusiveMinimum/exclusiveMaximum semantics); when strict is 0, values
 * equal to the boundary pass (minimum/maximum semantics).
 *
 * Writes 1-based failure indices into p_idx[0..n-1] and returns the number
 * of failures found.  NA values are always treated as passing (they are not
 * reported as range failures).
 */
static R_xlen_t check_dbl_real_core(
  const double* px,
  R_xlen_t n,
  double threshold,
  int type,
  int strict,
  int* p_idx
) {
  R_xlen_t n_fail = 0;
  if (type == 0) {
    /* min check: fail if x < threshold (or x <= threshold when strict) */
    for (R_xlen_t i = 0; i < n; i++) {
      double v = px[i];
      if (!ISNAN(v) && (strict ? v <= threshold : v < threshold)) {
        p_idx[n_fail++] = (int)(i + 1);
      }
    }
  } else {
    /* max check: fail if x > threshold (or x >= threshold when strict) */
    for (R_xlen_t i = 0; i < n; i++) {
      double v = px[i];
      if (!ISNAN(v) && (strict ? v >= threshold : v > threshold)) {
        p_idx[n_fail++] = (int)(i + 1);
      }
    }
  }
  return n_fail;
}

static R_xlen_t check_dbl_int_core(
  const int* px,
  R_xlen_t n,
  double threshold,
  int type,
  int strict,
  int* p_idx
) {
  R_xlen_t n_fail = 0;
  if (type == 0) {
    /* min check: fail if x < threshold (or x <= threshold when strict) */
    for (R_xlen_t i = 0; i < n; i++) {
      int v = px[i];
      if (v != NA_INTEGER) {
        double dv = (double)v;
        if (strict ? dv <= threshold : dv < threshold) {
          p_idx[n_fail++] = (int)(i + 1);
        }
      }
    }
  } else {
    /* max check: fail if x > threshold (or x >= threshold when strict) */
    for (R_xlen_t i = 0; i < n; i++) {
      int v = px[i];
      if (v != NA_INTEGER) {
        double dv = (double)v;
        if (strict ? dv >= threshold : dv > threshold) {
          p_idx[n_fail++] = (int)(i + 1);
        }
      }
    }
  }
  return n_fail;
}

/*
 * Shared implementation for stbl_check_min_dbl / stbl_check_max_dbl and their
 * exclusive counterparts.
 *
 * x         - a REALSXP or INTSXP vector
 * threshold - a length-1 REALSXP scalar
 * type      - 0 for min check (x < threshold), 1 for max check (x > threshold)
 * strict    - 0 for inclusive bounds, 1 for exclusive bounds (the boundary
 *             value itself fails)
 *
 * Returns R_NilValue (NULL) if all values pass, otherwise an INTSXP of
 * 1-based failure indices.
 */
static SEXP check_range_impl(SEXP x, SEXP threshold_sexp, int type, int strict) {
  R_xlen_t n = XLENGTH(x);
  double threshold = REAL(threshold_sexp)[0];

  /* Allocate a scratch buffer sized for the worst case */
  SEXP scratch = PROTECT(Rf_allocVector(INTSXP, n));
  int* p_idx = INTEGER(scratch);

  R_xlen_t n_fail;
  if (TYPEOF(x) == REALSXP) {
    n_fail = check_dbl_real_core(REAL(x), n, threshold, type, strict, p_idx);
  } else {
    /* INTSXP — stabilize_int() passes integer vectors here */
    n_fail = check_dbl_int_core(INTEGER(x), n, threshold, type, strict, p_idx);
  }

  if (n_fail == 0) {
    UNPROTECT(1);
    return R_NilValue;
  }

  SEXP out = PROTECT(Rf_allocVector(INTSXP, n_fail));
  int* p_out = INTEGER(out);
  for (R_xlen_t i = 0; i < n_fail; i++) {
    p_out[i] = p_idx[i];
  }
  UNPROTECT(2);
  return out;
}

/*
 * stbl_check_min_dbl: return 1-based integer indices where x < min_val.
 *
 * x       - a REALSXP or INTSXP vector
 * min_val - a length-1 REALSXP scalar
 *
 * Returns R_NilValue (NULL) if all values pass.
 */
SEXP stbl_check_min_dbl(SEXP x, SEXP min_val) {
  return check_range_impl(x, min_val, 0, 0);
}

/*
 * stbl_check_max_dbl: return 1-based integer indices where x > max_val.
 *
 * x       - a REALSXP or INTSXP vector
 * max_val - a length-1 REALSXP scalar
 *
 * Returns R_NilValue (NULL) if all values pass.
 */
SEXP stbl_check_max_dbl(SEXP x, SEXP max_val) {
  return check_range_impl(x, max_val, 1, 0);
}

/*
 * stbl_check_min_dbl_exclusive: return 1-based integer indices where
 * x <= min_val (JSON Schema exclusiveMinimum semantics).
 *
 * x       - a REALSXP or INTSXP vector
 * min_val - a length-1 REALSXP scalar
 *
 * Returns R_NilValue (NULL) if all values pass.
 */
SEXP stbl_check_min_dbl_exclusive(SEXP x, SEXP min_val) {
  return check_range_impl(x, min_val, 0, 1);
}

/*
 * stbl_check_max_dbl_exclusive: return 1-based integer indices where
 * x >= max_val (JSON Schema exclusiveMaximum semantics).
 *
 * x       - a REALSXP or INTSXP vector
 * max_val - a length-1 REALSXP scalar
 *
 * Returns R_NilValue (NULL) if all values pass.
 */
SEXP stbl_check_max_dbl_exclusive(SEXP x, SEXP max_val) {
  return check_range_impl(x, max_val, 1, 1);
}
