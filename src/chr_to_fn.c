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
 * Build and signal a classed error condition from C so that R-side
 * try_fetch() handlers can catch it by class name.  Calling stop() with a
 * condition object always unwinds -- these helpers never return.
 */
static void stbl_signal_classed_error(const char* cls0) {
  SEXP nms = PROTECT(Rf_allocVector(STRSXP, 1));
  SET_STRING_ELT(nms, 0, Rf_mkChar("message"));

  SEXP cond = PROTECT(Rf_allocVector(VECSXP, 1));
  SET_VECTOR_ELT(cond, 0, Rf_mkString(cls0)); /* message = class name */
  Rf_setAttrib(cond, R_NamesSymbol, nms);

  SEXP cls = PROTECT(Rf_allocVector(STRSXP, 3));
  SET_STRING_ELT(cls, 0, Rf_mkChar(cls0));
  SET_STRING_ELT(cls, 1, Rf_mkChar("error"));
  SET_STRING_ELT(cls, 2, Rf_mkChar("condition"));
  Rf_setAttrib(cond, R_ClassSymbol, cls);

  /* UNPROTECT is unreachable after this */
  Rf_eval(Rf_lang2(Rf_install("stop"), cond), R_BaseEnv);
}

static void stbl_signal_invalid_fn_name(void) {
  stbl_signal_classed_error("stbl_invalid_function_name");
}

static void stbl_signal_unknown_function(void) {
  stbl_signal_classed_error("stbl_unknown_function");
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
  stbl_signal_unknown_function(); /* always unwinds */
  return R_NilValue;              /* unreachable    */
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

  /* Validate colon usage: must be absent, or exactly one "::" with
   * non-empty identifiers on both sides and no other ":" anywhere. */
  {
    const char* first_colon = strchr(s, ':');
    if (first_colon != NULL) {
      const char* dcolon = strstr(s, "::");
      int invalid =
        dcolon == NULL           ||  /* ":" but no "::"          */
        first_colon < dcolon     ||  /* lone ":" before "::"     */
        dcolon == s              ||  /* "::" at start, empty pkg */
        *(dcolon + 2) == '\0'    ||  /* "::" at end, empty fn    */
        strchr(dcolon + 2, ':') != NULL; /* more ":" after "::"  */
      if (invalid) stbl_signal_invalid_fn_name();
    }
  }

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
