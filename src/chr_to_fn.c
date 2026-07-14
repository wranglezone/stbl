#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <ctype.h>
#include <string.h>

/*
 * Check whether a bare C string is a syntactically valid R identifier.
 *
 * Rules (simplified from ?make.names):
 *   - Non-empty
 *   - First character: a letter, or '.' followed by a letter or '_'
 *   - Remaining characters: letters, digits, '.', '_'
 *
 * This does not reject reserved words (e.g. "if", "TRUE"), matching
 * how are_*_ish() functions focus on representability rather than runtime
 * validity.
 */
static int is_valid_r_name(const char* s) {
  if (*s == '\0') return 0;

  if (isalpha((unsigned char)*s)) {
    s++;
  } else if (*s == '.') {
    s++;
    if (*s == '\0') return 0;
    if (!isalpha((unsigned char)*s) && *s != '_') return 0;
    s++;
  } else {
    return 0;
  }

  while (*s != '\0') {
    if (!isalnum((unsigned char)*s) && *s != '.' && *s != '_') return 0;
    s++;
  }
  return 1;
}

/*
 * Single-pass element-wise check: is each string a syntactically valid
 * function name (bare identifier or "pkg::fn")?
 *
 * NA strings and empty strings produce 0.  The check is purely syntactic;
 * it does not verify that the function exists in any environment.
 */
static void chr_are_fnish_core(SEXP x, R_xlen_t n, int* p_result) {
  for (R_xlen_t i = 0; i < n; i++) {
    SEXP xi = STRING_ELT(x, i);

    if (xi == NA_STRING) { p_result[i] = 0; continue; }

    const char* s = CHAR(xi);
    if (*s == '\0') { p_result[i] = 0; continue; }

    const char* sep = strstr(s, "::");
    if (sep != NULL) {
      /* Both sides of "::" must be non-empty */
      p_result[i] = (sep > s && *(sep + 2) != '\0') ? 1 : 0;
    } else {
      p_result[i] = is_valid_r_name(s) ? 1 : 0;
    }
  }
}

/*
 * stbl_chr_are_fnish: public API entry point.
 *
 * Returns a logical vector of length(x): TRUE for elements that are
 * syntactically valid function names, FALSE otherwise.
 */
SEXP stbl_chr_are_fnish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(LGLSXP, n));
  chr_are_fnish_core(x, n, LOGICAL(result));
  UNPROTECT(1);
  return result;
}

/*
 * stbl_chr_to_fn: public API entry point.
 *
 * Converts a length-1 character string to a function.  Length checks and
 * NULL handling are done in R before calling this.  Two paths:
 *
 *   "pkg::fn"  -- find namespace via R_FindNamespace(), look up function
 *   "name"     -- look up function in definition_env
 *
 * Rf_findFun() calls Rf_error() internally if the function is not found,
 * so no explicit error handling is needed for that case.
 */
SEXP stbl_chr_to_fn(SEXP x, SEXP definition_env) {
  SEXP xi = STRING_ELT(x, 0);
  if (xi == NA_STRING) Rf_error("Can't convert <NA> to a function.");
  const char* s = CHAR(xi);
  if (*s == '\0') Rf_error("Can't convert \"\" to a function.");

  const char* sep = strstr(s, "::");
  if (sep != NULL) {
    size_t pkg_len = (size_t)(sep - s);
    char* pkg = (char*)R_alloc(pkg_len + 1, sizeof(char));
    strncpy(pkg, s, pkg_len);
    pkg[pkg_len] = '\0';
    const char* fn_name = sep + 2;

    SEXP pkg_str = PROTECT(Rf_mkString(pkg));
    SEXP ns      = PROTECT(R_FindNamespace(pkg_str));
    SEXP sym     = Rf_install(fn_name);
    SEXP fn      = Rf_findFun(sym, ns);
    UNPROTECT(2);
    return fn;
  }

  SEXP sym = Rf_install(s);
  return Rf_findFun(sym, definition_env);
}
