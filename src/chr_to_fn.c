#include "stbl.h"
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
 * Validate colon usage in a potential function name.
 *
 * Accepts either no colons at all, or exactly one "::" with non-empty
 * tokens on both sides and no other ":" anywhere.  All other patterns
 * (bare ":", multiple "::", mixed ":" and "::") are rejected.
 *
 * Returns 1 if the colon usage is valid, 0 otherwise.
 */
static int is_valid_colon_usage(const char* s) {
  const char* first_colon = strchr(s, ':');
  if (first_colon == NULL) return 1;            /* no colons: fine          */

  const char* dcolon = strstr(s, "::");
  if (dcolon == NULL)                  return 0; /* ":" but no "::"          */
  if (first_colon < dcolon)            return 0; /* lone ":" before "::"     */
  if (dcolon == s)                     return 0; /* "::" at start, empty pkg */
  if (*(dcolon + 2) == '\0')           return 0; /* "::" at end, empty fn    */
  if (strchr(dcolon + 2, ':') != NULL) return 0; /* more ":" after "::"      */
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

    if (!is_valid_colon_usage(s)) { p_result[i] = 0; continue; }

    /* Valid colon usage: either a "pkg::fn" shape or a bare identifier */
    const char* sep = strstr(s, "::");
    p_result[i] = (sep != NULL) ? 1 : is_valid_r_name(s);
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

/* ---------------------------------------------------------------------------
 * R_tryCatchError wrappers for namespace + function lookup.
 *
 * Rf_findFun() and R_FindNamespace() call Rf_error() internally when they
 * fail.  We wrap them with R_tryCatchError() so that any plain error can be
 * re-signaled as a classed stbl_unknown_function condition that the R-side
 * try_fetch() can catch by name.
 * --------------------------------------------------------------------------*/

struct fn_lookup_data {
  const char* pkg;    /* NULL for bare-name lookup     */
  const char* fn;
  SEXP        env;    /* used when pkg is NULL         */
  SEXP        result;
};

static SEXP do_fn_lookup(void* data_) {
  struct fn_lookup_data* d = (struct fn_lookup_data*)data_;
  if (d->pkg != NULL) {
    SEXP pkg_str = PROTECT(Rf_mkString(d->pkg));
    SEXP ns      = PROTECT(R_FindNamespace(pkg_str));
    d->result    = Rf_findFun(Rf_install(d->fn), ns);
    UNPROTECT(2);
  } else {
    d->result = Rf_findFun(Rf_install(d->fn), d->env);
  }
  return R_NilValue;
}

static SEXP handle_fn_not_found(SEXP cond, void* data_) {
  return signal_classed_error("stbl_unknown_function");
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

  /* Validate colon usage via shared helper */
  if (!is_valid_colon_usage(s))
    return signal_classed_error("stbl_invalid_function_name");

  const char* sep = strstr(s, "::");
  if (sep != NULL) {
    size_t pkg_len = (size_t)(sep - s);
    char* pkg = (char*)R_alloc(pkg_len + 1, sizeof(char));
    strncpy(pkg, s, pkg_len);
    pkg[pkg_len] = '\0';
    struct fn_lookup_data d = {pkg, sep + 2, R_NilValue, R_NilValue};
    R_tryCatchError(do_fn_lookup, &d, handle_fn_not_found, NULL);
    return d.result;
  }

  struct fn_lookup_data d = {NULL, s, definition_env, R_NilValue};
  R_tryCatchError(do_fn_lookup, &d, handle_fn_not_found, NULL);
  return d.result;
}
