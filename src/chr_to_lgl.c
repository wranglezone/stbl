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
 * Core single-pass character-to-logical conversion.
 *
 * Fills p_result[0..n-1] and p_valid[0..n-1]:
 *   p_result: the converted logical values (NA_LOGICAL where conversion failed)
 *   p_valid:  1 for elements that converted successfully, 0 otherwise
 *
 * Recognises (case-insensitively): "TRUE"/"T" -> TRUE, "FALSE"/"F" -> FALSE,
 * NA_STRING -> NA (valid), and any string parseable as a finite non-NaN double
 * (via R_strtod) -> (double != 0.0).  Everything else is invalid.
 */
static void chr_to_lgl_core(SEXP x, R_xlen_t n, int* p_result, int* p_valid) {
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
}

/*
 * ffi_chr_to_lgl: internal FFI entry point used by stbl itself.
 *
 * Returns a named list of two logical vectors of length(x):
 *   $result: the converted logical values (NA where conversion failed)
 *   $valid:  TRUE for elements that converted successfully, FALSE otherwise
 */
SEXP ffi_chr_to_lgl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  chr_to_lgl_core(x, n, LOGICAL(result), LOGICAL(valid));

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SET_VECTOR_ELT(out, 0, result);
  SET_VECTOR_ELT(out, 1, valid);
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_STRING_ELT(names, 0, Rf_mkChar("result"));
  SET_STRING_ELT(names, 1, Rf_mkChar("valid"));
  Rf_setAttrib(out, R_NamesSymbol, names);
  UNPROTECT(4);
  return out;
}

/*
 * stbl_chr_to_lgl: public API entry point.
 *
 * Returns a logical vector of length(x) with the converted values
 * (NA where conversion failed).
 */
SEXP stbl_chr_to_lgl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  chr_to_lgl_core(x, n, LOGICAL(result), LOGICAL(valid));
  UNPROTECT(2);
  return result;
}

/*
 * stbl_chr_are_lglish: public API entry point.
 *
 * Returns a logical vector of length(x) that is TRUE for elements that can
 * be coerced to logical, FALSE otherwise.
 */
SEXP stbl_chr_are_lglish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  chr_to_lgl_core(x, n, LOGICAL(result), LOGICAL(valid));
  UNPROTECT(2);
  return valid;
}
