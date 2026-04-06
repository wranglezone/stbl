#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>
#include <R_ext/Utils.h>
#include <ctype.h>

/* Case-insensitive check for "T" or "TRUE" */
static int is_true_str(const char* s) {
  if ((s[0] == 'T' || s[0] == 't') && s[1] == '\0') return 1;
  if ((s[0] == 'T' || s[0] == 't') &&
      (s[1] == 'R' || s[1] == 'r') &&
      (s[2] == 'U' || s[2] == 'u') &&
      (s[3] == 'E' || s[3] == 'e') &&
      s[4] == '\0') return 1;
  return 0;
}

/* Case-insensitive check for "F" or "FALSE" */
static int is_false_str(const char* s) {
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
 * Single-pass character-to-logical conversion.
 *
 * Returns a list of two logical vectors of length(x):
 *   [[1]] result: the converted logical values (NA where conversion failed)
 *   [[2]] valid:  TRUE for elements that converted successfully, FALSE otherwise
 *
 * Recognises (case-insensitively): "TRUE"/"T" -> TRUE, "FALSE"/"F" -> FALSE,
 * NA_STRING -> NA (valid), and any string parseable as a finite non-NaN double
 * (via R_strtod) -> (double != 0.0).  Everything else is invalid.
 */
SEXP stbl_lgl_from_chr(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  int* p_result = LOGICAL(result);
  int* p_valid  = LOGICAL(valid);

  for (R_xlen_t i = 0; i < n; i++) {
    SEXP xi = STRING_ELT(x, i);

    if (xi == NA_STRING) {
      p_result[i] = NA_LOGICAL;
      p_valid[i]  = 1;
      continue;
    }

    const char* s = CHAR(xi);

    if (is_true_str(s)) {
      p_result[i] = 1;
      p_valid[i]  = 1;
      continue;
    }

    if (is_false_str(s)) {
      p_result[i] = 0;
      p_valid[i]  = 1;
      continue;
    }

    /* Try parsing as a double using R's own parser (matches as.double() behaviour).
       Reject NaN: R treats NaN as NA (is.na(NaN) == TRUE), so are_dbl_ish("NaN")
       is FALSE and "NaN" is not a valid logical.  Inf/-Inf are accepted because
       is.na(Inf) == FALSE and to_lgl("Inf") == TRUE in R. */
    char* endptr;
    double dval = R_strtod(s, &endptr);
    /* endptr == s means no numeric characters were consumed at all */
    if (endptr == s) {
      p_result[i] = NA_LOGICAL;
      p_valid[i]  = 0;
      continue;
    }
    /* Skip trailing whitespace: R's coercion to double accepts it.
       The loop is safe because s is a null-terminated C string and '\0' is
       not a whitespace character, so the loop always terminates. */
    while (isspace((unsigned char)*endptr)) endptr++;
    if (*endptr == '\0' && !ISNAN(dval)) {
      p_result[i] = (dval != 0.0) ? 1 : 0;
      p_valid[i]  = 1;
    } else {
      p_result[i] = NA_LOGICAL;
      p_valid[i]  = 0;
    }
  }

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SET_VECTOR_ELT(out, 0, result);
  SET_VECTOR_ELT(out, 1, valid);
  UNPROTECT(3);
  return out;
}
