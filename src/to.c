#include "stbl.h"

/* Forward declarations for all conversion functions called below */
SEXP stbl_chr_to_dbl(SEXP x);
SEXP stbl_chr_to_int(SEXP x);
SEXP stbl_chr_to_lgl(SEXP x);

SEXP stbl_dbl_to_chr(SEXP x);
SEXP stbl_dbl_to_int(SEXP x);
SEXP stbl_dbl_to_lgl(SEXP x);

SEXP stbl_fct_to_chr(SEXP x);
SEXP stbl_fct_to_dbl(SEXP x);
SEXP stbl_fct_to_int(SEXP x);
SEXP stbl_fct_to_lgl(SEXP x);

SEXP stbl_int_to_chr(SEXP x);
SEXP stbl_int_to_dbl(SEXP x);

SEXP stbl_lgl_to_chr(SEXP x);
SEXP stbl_lgl_to_dbl(SEXP x);
SEXP stbl_lgl_to_int(SEXP x);

SEXP stbl_lst_to_chr(SEXP x);
SEXP stbl_lst_to_dbl(SEXP x);
SEXP stbl_lst_to_int(SEXP x);
SEXP stbl_lst_to_lgl(SEXP x);

/* ── Helpers ──────────────────────────────────────────────────────────── */

/*
 * Extract the `result` element (index 0) from the list returned by all
 * stbl_*_to_*() functions.  Safe to call after PROTECT(res) and before
 * UNPROTECT(1) – no allocation occurs between the two.
 */
static SEXP result_of(SEXP res) {
  return VECTOR_ELT(res, 0);
}

/*
 * Check the `valid` element (index 1) of a two-element result list.
 * Calls Rf_error() if any element is FALSE.
 */
static SEXP check_valid(SEXP res, const char* to_class) {
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
static SEXP check_precision(SEXP res, const char* from_class) {
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
static SEXP check_int_cast(SEXP res, const char* from_class) {
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

/* ── stbl_to ──────────────────────────────────────────────────────────── */

/*
 * stbl_to: coerce x to the type of to.
 *
 * Dispatches on typeof(to) and typeof(x), calling the appropriate C
 * conversion routine.  Supported target types: logical, integer, double,
 * character.  Factor and list targets are not handled here; use the R-level
 * to() wrapper, which delegates those cases to to_fct() and to_lst().
 *
 * NULL x is returned unchanged for all target types (matching the behaviour
 * of the individual to_*() functions when allow_null = TRUE).
 *
 * On conversion failure Rf_error() is called with a basic error message.
 * For richly formatted rlang errors, call the R-level to() instead.
 */
SEXP stbl_to(SEXP x, SEXP to) {
  int x_type  = TYPEOF(x);
  int to_type = TYPEOF(to);

  /* NULL input passes through unchanged */
  if (x_type == NILSXP) return x;

  /* factor and list targets must be handled by the R wrapper */
  if (to_type == INTSXP && Rf_inherits(to, "factor")) {
    Rf_error("Factor targets are not supported by stbl_to(); use to() from R.");
  }
  if (to_type == VECSXP) {
    Rf_error("List targets are not supported by stbl_to(); use to() from R.");
  }

  SEXP res;

  switch (to_type) {

    /* ── to logical ──────────────────────────────────────────────────── */
    case LGLSXP:
      if (x_type == LGLSXP) return x;
      if (x_type == INTSXP) {
        if (Rf_inherits(x, "factor")) {
          res = PROTECT(stbl_fct_to_lgl(x));
          SEXP out = check_valid(res, "logical");
          UNPROTECT(1);
          return out;
        }
        /* plain integer: stbl_dbl_to_lgl handles INTSXP inputs */
        res = PROTECT(stbl_dbl_to_lgl(x));
        SEXP out = result_of(res);
        UNPROTECT(1);
        return out;
      }
      if (x_type == REALSXP) {
        res = PROTECT(stbl_dbl_to_lgl(x));
        SEXP out = result_of(res);
        UNPROTECT(1);
        return out;
      }
      if (x_type == STRSXP) {
        res = PROTECT(stbl_chr_to_lgl(x));
        SEXP out = check_valid(res, "logical");
        UNPROTECT(1);
        return out;
      }
      if (x_type == VECSXP) {
        res = PROTECT(stbl_lst_to_lgl(x));
        SEXP out = check_valid(res, "logical");
        UNPROTECT(1);
        return out;
      }
      Rf_error("Can't convert to <logical>.");

    /* ── to integer ──────────────────────────────────────────────────── */
    case INTSXP:
      if (x_type == INTSXP) {
        if (Rf_inherits(x, "factor")) {
          res = PROTECT(stbl_fct_to_int(x));
          SEXP out = check_int_cast(res, "factor");
          UNPROTECT(1);
          return out;
        }
        return x;
      }
      if (x_type == LGLSXP) {
        res = PROTECT(stbl_lgl_to_int(x));
        SEXP out = result_of(res);
        UNPROTECT(1);
        return out;
      }
      if (x_type == REALSXP) {
        res = PROTECT(stbl_dbl_to_int(x));
        SEXP out = check_precision(res, "double");
        UNPROTECT(1);
        return out;
      }
      if (x_type == STRSXP) {
        res = PROTECT(stbl_chr_to_int(x));
        SEXP out = check_int_cast(res, "character");
        UNPROTECT(1);
        return out;
      }
      if (x_type == VECSXP) {
        res = PROTECT(stbl_lst_to_int(x));
        SEXP out = check_valid(res, "integer");
        UNPROTECT(1);
        return out;
      }
      Rf_error("Can't convert to <integer>.");

    /* ── to double ───────────────────────────────────────────────────── */
    case REALSXP:
      if (x_type == REALSXP) return x;
      if (x_type == INTSXP) {
        if (Rf_inherits(x, "factor")) {
          res = PROTECT(stbl_fct_to_dbl(x));
          SEXP out = check_valid(res, "double");
          UNPROTECT(1);
          return out;
        }
        res = PROTECT(stbl_int_to_dbl(x));
        SEXP out = result_of(res);
        UNPROTECT(1);
        return out;
      }
      if (x_type == LGLSXP) {
        res = PROTECT(stbl_lgl_to_dbl(x));
        SEXP out = result_of(res);
        UNPROTECT(1);
        return out;
      }
      if (x_type == STRSXP) {
        res = PROTECT(stbl_chr_to_dbl(x));
        SEXP out = check_valid(res, "double");
        UNPROTECT(1);
        return out;
      }
      if (x_type == VECSXP) {
        res = PROTECT(stbl_lst_to_dbl(x));
        SEXP out = check_valid(res, "double");
        UNPROTECT(1);
        return out;
      }
      Rf_error("Can't convert to <double>.");

    /* ── to character ────────────────────────────────────────────────── */
    case STRSXP:
      if (x_type == STRSXP) return x;
      if (x_type == INTSXP) {
        if (Rf_inherits(x, "factor")) {
          res = PROTECT(stbl_fct_to_chr(x));
          SEXP out = result_of(res);
          UNPROTECT(1);
          return out;
        }
        res = PROTECT(stbl_int_to_chr(x));
        SEXP out = result_of(res);
        UNPROTECT(1);
        return out;
      }
      if (x_type == REALSXP) {
        res = PROTECT(stbl_dbl_to_chr(x));
        SEXP out = result_of(res);
        UNPROTECT(1);
        return out;
      }
      if (x_type == LGLSXP) {
        res = PROTECT(stbl_lgl_to_chr(x));
        SEXP out = result_of(res);
        UNPROTECT(1);
        return out;
      }
      if (x_type == VECSXP) {
        res = PROTECT(stbl_lst_to_chr(x));
        SEXP out = check_valid(res, "character");
        UNPROTECT(1);
        return out;
      }
      Rf_error("Can't convert to <character>.");

    default:
      Rf_error("Unsupported target type in stbl_to().");
  }

  return R_NilValue; /* not reached: all switch cases above return or error */
}
