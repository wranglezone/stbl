#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>

/*
 * Scan a REALSXP or INTSXP vector for values below (type=0) or above
 * (type=1) the threshold.
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
  int* p_idx
) {
  R_xlen_t n_fail = 0;
  if (type == 0) {
    /* min check: fail if x < threshold */
    for (R_xlen_t i = 0; i < n; i++) {
      double v = px[i];
      if (!ISNAN(v) && v < threshold) {
        p_idx[n_fail++] = (int)(i + 1);
      }
    }
  } else {
    /* max check: fail if x > threshold */
    for (R_xlen_t i = 0; i < n; i++) {
      double v = px[i];
      if (!ISNAN(v) && v > threshold) {
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
  int* p_idx
) {
  R_xlen_t n_fail = 0;
  if (type == 0) {
    /* min check: fail if x < threshold */
    for (R_xlen_t i = 0; i < n; i++) {
      int v = px[i];
      if (v != NA_INTEGER && (double)v < threshold) {
        p_idx[n_fail++] = (int)(i + 1);
      }
    }
  } else {
    /* max check: fail if x > threshold */
    for (R_xlen_t i = 0; i < n; i++) {
      int v = px[i];
      if (v != NA_INTEGER && (double)v > threshold) {
        p_idx[n_fail++] = (int)(i + 1);
      }
    }
  }
  return n_fail;
}

/*
 * Shared implementation for stbl_check_min_dbl / stbl_check_max_dbl.
 *
 * x         - a REALSXP or INTSXP vector
 * threshold - a length-1 REALSXP scalar
 * type      - 0 for min check (x < threshold), 1 for max check (x > threshold)
 *
 * Returns R_NilValue (NULL) if all values pass, otherwise an INTSXP of
 * 1-based failure indices.
 */
static SEXP check_range_impl(SEXP x, SEXP threshold_sexp, int type) {
  R_xlen_t n = XLENGTH(x);
  double threshold = REAL(threshold_sexp)[0];

  /* Allocate a scratch buffer sized for the worst case */
  SEXP scratch = PROTECT(Rf_allocVector(INTSXP, n));
  int* p_idx = INTEGER(scratch);

  R_xlen_t n_fail;
  if (TYPEOF(x) == REALSXP) {
    n_fail = check_dbl_real_core(REAL(x), n, threshold, type, p_idx);
  } else {
    /* INTSXP — stabilize_int() passes integer vectors here */
    n_fail = check_dbl_int_core(INTEGER(x), n, threshold, type, p_idx);
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
  return check_range_impl(x, min_val, 0);
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
  return check_range_impl(x, max_val, 1);
}
