#include "to.h"
#include <string.h>

/*
 * stbl_reconcile: the core of the R-level reconcile().
 *
 * Takes a list of values (at least one) and checks that every value is
 * equivalent to every other value, following the rules documented in
 * ?reconcile. Returns list(result, mismatch). On success, `result` is the
 * narrowest common representation and `mismatch` is NULL. Otherwise `result`
 * is NULL and `mismatch` is list(i, j, at, reason), where:
 *   - i, j:   1-based positions in `values` of the first pair that disagree.
 *   - at:     integer vector of 1-based positions that lead from the top-level
 *             values to the first difference within lists and data frames
 *             (integer(0) at the top level). Positions follow `values[[1]]`.
 *   - reason: one of the STBL_RECONCILE_* codes below.
 * The R side turns these into the classed error, as to_fail() does for
 * conversions.
 */

/* Keep in sync with inst/include/stbl.h. */
#define STBL_RECONCILE_NO_REASON       0
#define STBL_RECONCILE_LENGTHS         1
#define STBL_RECONCILE_NAMES           2
#define STBL_RECONCILE_ORDERING        3
#define STBL_RECONCILE_LEVELS          4
#define STBL_RECONCILE_TIME_ZONES      5
#define STBL_RECONCILE_CLASSES         6
#define STBL_RECONCILE_COLUMN_NAMES    7
#define STBL_RECONCILE_ROW_NAMES       8
#define STBL_RECONCILE_ATTRIBUTES      9

/* Flags for R_compute_identical() that match the defaults of identical(). */
#define IDENTICAL_DEFAULT 16

SEXP stbl_chr_to_lgl(SEXP x);
SEXP stbl_chr_to_int(SEXP x);
SEXP stbl_chr_to_dbl(SEXP x);
SEXP stbl_chr_to_fct(SEXP value, SEXP levels, SEXP ordered);
SEXP stbl_dbl_to_lgl(SEXP x);
SEXP stbl_dbl_to_chr(SEXP x);
SEXP stbl_int_to_chr(SEXP x);
SEXP stbl_int_to_fct(SEXP value, SEXP levels, SEXP ordered);
SEXP stbl_lgl_to_dbl(SEXP x);
SEXP stbl_lgl_to_int(SEXP x);
SEXP stbl_lgl_to_chr(SEXP x);
SEXP stbl_fct_to_lgl(SEXP x);
SEXP stbl_fct_to_int(SEXP x);
SEXP stbl_fct_to_dbl(SEXP x);
SEXP stbl_fct_to_chr(SEXP x);

/* Ranked types, in the order of .reconcile_ranking in R/reconcile.R
 * (narrowest first). T_NONE is a type outside the ranking. */
enum {
  T_NONE = 0, T_FCT, T_DATE, T_POSIXCT, T_HMS, T_PERIOD,
  T_LGL, T_INT, T_DBL, T_CHR
};

enum { C_NULL = 0, C_FUNCTION, C_DATA_FRAME, C_ATOMIC, C_LIST, C_OTHER };

/* Where the first difference is, built up while the recursion unwinds. */
typedef struct {
  int i;
  int j;
  int reason;
  R_xlen_t* at;  /* leaf first; allocated with R_alloc() */
  R_xlen_t n_at;
  R_xlen_t cap_at;
} mismatch_t;

static void set_mismatch(mismatch_t* mm, int i, int j, int reason) {
  mm->i = i;
  mm->j = j;
  mm->reason = reason;
}

static void push_at(mismatch_t* mm, R_xlen_t pos) {
  if (mm->n_at == mm->cap_at) {
    R_xlen_t new_cap = mm->cap_at ? mm->cap_at * 2 : 8;
    R_xlen_t* bigger = (R_xlen_t*) R_alloc(new_cap, sizeof(R_xlen_t));
    if (mm->n_at) memcpy(bigger, mm->at, mm->n_at * sizeof(R_xlen_t));
    mm->at = bigger;
    mm->cap_at = new_cap;
  }
  mm->at[mm->n_at++] = pos;
}

static inline int identical(SEXP x, SEXP y) {
  return R_compute_identical(x, y, IDENTICAL_DEFAULT);
}

/* Evaluate the R function `.atomic_mismatch(x, y)` from the stbl namespace.
 * Values are bound in an environment so language objects stay data. */
static int r_atomic_mismatch(SEXP x, SEXP y) {
  SEXP ns = PROTECT(R_FindNamespace(Rf_mkString("stbl")));
  SEXP env = PROTECT(R_NewEnv(ns, 0, 0));
  Rf_defineVar(Rf_install("x"), x, env);
  Rf_defineVar(Rf_install("y"), y, env);
  SEXP call = PROTECT(
    Rf_lang3(Rf_install(".atomic_mismatch"), Rf_install("x"), Rf_install("y"))
  );
  SEXP res = PROTECT(Rf_eval(call, env));
  int out = Rf_asInteger(res);
  UNPROTECT(4);
  return out;
}

/* attributes(x), as an R list (or NULL). The public C API can't enumerate
 * attributes, so ask R. */
static SEXP attributes_of(SEXP x) {
  SEXP env = PROTECT(R_NewEnv(R_BaseEnv, 0, 0));
  Rf_defineVar(Rf_install("x"), x, env);
  SEXP call = PROTECT(Rf_lang2(Rf_install("attributes"), Rf_install("x")));
  SEXP out = Rf_eval(call, env);
  UNPROTECT(2);
  return out;
}

/* The element of a list called `name`, or NULL (C) if it has none. */
static SEXP named_elt(SEXP list, const char* name) {
  SEXP names = Rf_getAttrib(list, R_NamesSymbol);
  for (R_xlen_t i = 0; i < XLENGTH(list); i++) {
    if (strcmp(CHAR(STRING_ELT(names, i)), name) == 0) {
      return VECTOR_ELT(list, i);
    }
  }
  return NULL;
}

/* Types ---------------------------------------------------------------- */

static int atomic_type(SEXP x) {
  if (Rf_inherits(x, "factor")) return T_FCT;
  if (Rf_inherits(x, "Date")) return T_DATE;
  if (Rf_inherits(x, "POSIXct")) return T_POSIXCT;
  if (Rf_inherits(x, "hms")) return T_HMS;
  if (Rf_inherits(x, "Period")) return T_PERIOD;
  if (Rf_isObject(x)) return T_NONE;
  switch (TYPEOF(x)) {
    case LGLSXP:  return T_LGL;
    case INTSXP:  return T_INT;
    case REALSXP: return T_DBL;
    case STRSXP:  return T_CHR;
    default:      return T_NONE;
  }
}

static int category(SEXP x) {
  int type = TYPEOF(x);
  if (type == NILSXP) return C_NULL;
  if (type == CLOSXP || type == BUILTINSXP || type == SPECIALSXP) {
    return C_FUNCTION;
  }
  if (Rf_inherits(x, "data.frame")) return C_DATA_FRAME;
  if (atomic_type(x) != T_NONE) return C_ATOMIC;
  if ((type == VECSXP || type == LISTSXP) && !Rf_isObject(x)) return C_LIST;
  if (Rf_isVectorAtomic(x)) return C_ATOMIC;
  return C_OTHER;
}

/* Atomic equivalence --------------------------------------------------- */

/* Objects whose length() and names() we can read without S3/S4 dispatch. */
static int dispatch_safe(SEXP x) {
  if (!Rf_isObject(x)) return 1;
  return Rf_inherits(x, "factor") || Rf_inherits(x, "Date") ||
         Rf_inherits(x, "POSIXct");
}

/* A plain logical, integer, double, or character vector (only names), or a
 * standard factor (only names, levels, and class). */
static int is_plain(SEXP x, int type) {
  SEXP attrs = PROTECT(attributes_of(x));
  int plain = 1;
  if (attrs != R_NilValue) {
    SEXP names = Rf_getAttrib(attrs, R_NamesSymbol);
    for (R_xlen_t i = 0; i < XLENGTH(attrs) && plain; i++) {
      const char* name = CHAR(STRING_ELT(names, i));
      if (strcmp(name, "names") == 0) continue;
      if (type == T_FCT &&
          (strcmp(name, "levels") == 0 || strcmp(name, "class") == 0)) {
        continue;
      }
      plain = 0;
    }
  }
  UNPROTECT(1);
  if (!plain || type != T_FCT) return plain;

  if (TYPEOF(x) != INTSXP || TYPEOF(Rf_getAttrib(x, R_LevelsSymbol)) != STRSXP) {
    return 0;
  }
  SEXP cls = Rf_getAttrib(x, R_ClassSymbol);
  if (TYPEOF(cls) != STRSXP) return 0;
  if (XLENGTH(cls) == 1) return strcmp(CHAR(STRING_ELT(cls, 0)), "factor") == 0;
  return XLENGTH(cls) == 2 &&
    strcmp(CHAR(STRING_ELT(cls, 0)), "ordered") == 0 &&
    strcmp(CHAR(STRING_ELT(cls, 1)), "factor") == 0;
}

/* The result of a conversion, if every element converted. These only read,
 * so they are safe to call on an unprotected result. R_NilValue means the
 * conversion failed. */
static SEXP result_if_valid(SEXP res) {
  SEXP valid = VECTOR_ELT(res, 1);
  R_xlen_t n = XLENGTH(valid);
  int* p = LOGICAL(valid);
  for (R_xlen_t i = 0; i < n; i++) {
    if (!p[i]) return R_NilValue;
  }
  return VECTOR_ELT(res, 0);
}

/* Same, for results that flag failures (bad_precision) instead. */
static SEXP result_if_no_flags(SEXP res, R_xlen_t n_flags) {
  for (R_xlen_t k = 1; k <= n_flags; k++) {
    SEXP flag = VECTOR_ELT(res, k);
    R_xlen_t n = XLENGTH(flag);
    int* p = LOGICAL(flag);
    for (R_xlen_t i = 0; i < n; i++) {
      if (p[i]) return R_NilValue;
    }
  }
  return VECTOR_ELT(res, 0);
}

static SEXP result_of_always(SEXP res) {
  return VECTOR_ELT(res, 0);
}

/* A factor made from a character result, using the levels of `y`. */
static SEXP chr_to_fct_like(SEXP chr, SEXP y) {
  SEXP levels = Rf_getAttrib(y, R_LevelsSymbol);
  if (XLENGTH(levels) == 0) levels = R_NilValue;
  SEXP ordered = PROTECT(Rf_ScalarLogical(Rf_inherits(y, "ordered")));
  SEXP res = PROTECT(stbl_chr_to_fct(chr, levels, ordered));
  SEXP out = result_if_valid(res);
  UNPROTECT(2);
  return out;
}

/*
 * Convert `x` (of ranked type `tx`) to the type of `y` (of ranked type `ty`)
 * with the stbl conversion routines, as to(x, y) would. Both must be plain
 * logical, integer, double, character, or factor vectors, of different
 * types other than integer and double (see int_dbl_equivalent()). Returns 
 * R_NilValue if the conversion fails.
 */
static SEXP convert_like(SEXP x, int tx, SEXP y, int ty) {
  SEXP res, chr, out;
  switch (ty) {
    case T_LGL:
      switch (tx) {
        case T_INT:
        case T_DBL:
          res = PROTECT(stbl_dbl_to_lgl(x));
          out = result_of_always(res);
          break;
        case T_CHR:
          res = PROTECT(stbl_chr_to_lgl(x));
          out = result_if_valid(res);
          break;
        default: /* T_FCT */
          res = PROTECT(stbl_fct_to_lgl(x));
          out = result_if_valid(res);
      }
      UNPROTECT(1);
      return out;
    case T_INT:
      switch (tx) {
        case T_LGL:
          res = PROTECT(stbl_lgl_to_int(x));
          out = result_of_always(res);
          break;
        case T_CHR:
          res = PROTECT(stbl_chr_to_int(x));
          out = result_if_no_flags(res, 2);
          break;
        default: /* T_FCT */
          res = PROTECT(stbl_fct_to_int(x));
          out = result_if_no_flags(res, 2);
      }
      UNPROTECT(1);
      return out;
    case T_DBL:
      switch (tx) {
        case T_LGL:
          res = PROTECT(stbl_lgl_to_dbl(x));
          out = result_of_always(res);
          break;
        case T_CHR:
          res = PROTECT(stbl_chr_to_dbl(x));
          out = result_if_valid(res);
          break;
        default: /* T_FCT */
          res = PROTECT(stbl_fct_to_dbl(x));
          out = result_if_valid(res);
      }
      UNPROTECT(1);
      return out;
    case T_CHR:
      switch (tx) {
        case T_LGL:
          res = PROTECT(stbl_lgl_to_chr(x));
          break;
        case T_INT:
          res = PROTECT(stbl_int_to_chr(x));
          break;
        case T_DBL:
          res = PROTECT(stbl_dbl_to_chr(x));
          break;
        default: /* T_FCT */
          res = PROTECT(stbl_fct_to_chr(x));
      }
      out = result_of_always(res);
      UNPROTECT(1);
      return out;
    default: /* T_FCT */
      switch (tx) {
        case T_CHR:
          return chr_to_fct_like(x, y);
        case T_INT: {
          SEXP levels = Rf_getAttrib(y, R_LevelsSymbol);
          if (XLENGTH(levels) == 0) levels = R_NilValue;
          SEXP ordered = PROTECT(Rf_ScalarLogical(Rf_inherits(y, "ordered")));
          res = PROTECT(stbl_int_to_fct(x, levels, ordered));
          out = result_if_valid(res);
          UNPROTECT(2);
          return out;
        }
        case T_DBL:
          chr = PROTECT(stbl_dbl_to_chr(x));
          break;
        default: /* T_LGL */
          chr = PROTECT(stbl_lgl_to_chr(x));
      }
      out = chr_to_fct_like(result_of_always(chr), y);
      UNPROTECT(1);
      return out;
  }
}

/* identical(to(x, y), y) */
static int round_trips(SEXP x, int tx, SEXP y, int ty) {
  SEXP converted = PROTECT(convert_like(x, tx, y, ty));
  int ok = converted != R_NilValue && identical(converted, y);
  UNPROTECT(1);
  return ok;
}

/* Integer and double vectors are equivalent when every pair of elements is
 * NA/NA, or the double is a whole number equal to the integer. NaN is not
 * equivalent to an integer NA. */
static int int_dbl_equivalent(SEXP x_int, SEXP y_dbl) {
  R_xlen_t n = XLENGTH(x_int);
  const int* px = INTEGER(x_int);
  const double* py = REAL(y_dbl);
  for (R_xlen_t i = 0; i < n; i++) {
    if (px[i] == NA_INTEGER) {
      if (!R_IsNA(py[i])) return 0;
    } else if (py[i] != (double) px[i]) {
      return 0;
    }
  }
  return 1;
}

/* The specific reason two values of the same type aren't identical. */
static int same_type_reason(SEXP x, SEXP y, int type) {
  if (type == T_FCT) {
    if (!identical(Rf_getAttrib(x, R_ClassSymbol), Rf_getAttrib(y, R_ClassSymbol))) {
      return STBL_RECONCILE_ORDERING;
    }
    if (!identical(Rf_getAttrib(x, R_LevelsSymbol), Rf_getAttrib(y, R_LevelsSymbol))) {
      return STBL_RECONCILE_LEVELS;
    }
  }
  if (type == T_POSIXCT) {
    SEXP tzone = Rf_install("tzone");
    if (!identical(Rf_getAttrib(x, tzone), Rf_getAttrib(y, tzone))) {
      return STBL_RECONCILE_TIME_ZONES;
    }
  }
  return STBL_RECONCILE_NO_REASON;
}

/* Leave the comparison to the R implementation of the pair. */
static int atomics_equivalent_in_r(SEXP x, SEXP y, int* reason) {
  int r = r_atomic_mismatch(x, y);
  if (r < 0) return 1;
  *reason = r;
  return 0;
}

/* Whether two atomic vectors are equivalent. If not, `reason` is set. */
static int atomics_equivalent(SEXP x, SEXP y, int* reason) {
  *reason = STBL_RECONCILE_NO_REASON;

  if (!dispatch_safe(x) || !dispatch_safe(y)) {
    return atomics_equivalent_in_r(x, y, reason);
  }
  if (Rf_length(x) != Rf_length(y)) {
    *reason = STBL_RECONCILE_LENGTHS;
    return 0;
  }
  if (!identical(Rf_getAttrib(x, R_NamesSymbol), Rf_getAttrib(y, R_NamesSymbol))) {
    *reason = STBL_RECONCILE_NAMES;
    return 0;
  }

  int tx = atomic_type(x);
  int ty = atomic_type(y);
  if (tx == T_NONE || ty == T_NONE) {
    return atomics_equivalent_in_r(x, y, reason);
  }
  if (tx == ty) {
    if (identical(x, y)) return 1;
    *reason = same_type_reason(x, y, tx);
    return 0;
  }
  /* Dates and date-times depend on time zones, which stay in R. */
  if ((tx >= T_DATE && tx <= T_PERIOD) || (ty >= T_DATE && ty <= T_PERIOD) ||
      !is_plain(x, tx) || !is_plain(y, ty)) {
    return atomics_equivalent_in_r(x, y, reason);
  }
  if (tx == T_INT && ty == T_DBL) return int_dbl_equivalent(x, y);
  if (tx == T_DBL && ty == T_INT) return int_dbl_equivalent(y, x);
  return round_trips(x, tx, y, ty) && round_trips(y, ty, x, tx);
}

/* Containers ----------------------------------------------------------- */

static SEXP list_elt(SEXP x, R_xlen_t i) {
  if (TYPEOF(x) == LISTSXP) return CAR(Rf_nthcdr(x, (int) i));
  return VECTOR_ELT(x, i);
}

/* Whether the attributes of `x` and `y` other than names are identical,
 * compared as a set. attributes() reports row names in their expanded form,
 * so that is what is compared. */
static int other_attributes_identical(SEXP x, SEXP y) {
  SEXP ax = PROTECT(attributes_of(x));
  SEXP ay = PROTECT(attributes_of(y));
  int same = 1;
  R_xlen_t nx = 0, ny = 0;
  if (ay != R_NilValue) {
    SEXP names = Rf_getAttrib(ay, R_NamesSymbol);
    for (R_xlen_t i = 0; i < XLENGTH(ay); i++) {
      if (strcmp(CHAR(STRING_ELT(names, i)), "names") != 0) ny++;
    }
  }
  if (ax != R_NilValue) {
    SEXP names = Rf_getAttrib(ax, R_NamesSymbol);
    for (R_xlen_t i = 0; i < XLENGTH(ax) && same; i++) {
      const char* name = CHAR(STRING_ELT(names, i));
      if (strcmp(name, "names") == 0) continue;
      nx++;
      SEXP other = ay == R_NilValue ? NULL : named_elt(ay, name);
      same = other != NULL && identical(VECTOR_ELT(ax, i), other);
    }
  }
  UNPROTECT(2);
  return same && nx == ny;
}

static int container_difference(SEXP x, SEXP y, int is_df) {
  if (is_df &&
      !identical(Rf_getAttrib(x, R_ClassSymbol), Rf_getAttrib(y, R_ClassSymbol))) {
    return STBL_RECONCILE_CLASSES;
  }
  if (!is_df && Rf_length(x) != Rf_length(y)) return STBL_RECONCILE_LENGTHS;
  if (!identical(Rf_getAttrib(x, R_NamesSymbol), Rf_getAttrib(y, R_NamesSymbol))) {
    return is_df ? STBL_RECONCILE_COLUMN_NAMES : STBL_RECONCILE_NAMES;
  }
  if (is_df &&
      !identical(Rf_getAttrib(x, R_RowNamesSymbol), Rf_getAttrib(y, R_RowNamesSymbol))) {
    return STBL_RECONCILE_ROW_NAMES;
  }
  if (!other_attributes_identical(x, y)) return STBL_RECONCILE_ATTRIBUTES;
  return STBL_RECONCILE_NO_REASON;
}

/* Give `out` the attributes of the list or data frame `first`. */
static void copy_container_attributes(SEXP first, SEXP out) {
  if (TYPEOF(first) == LISTSXP) {
    copy_names(first, out);
  } else {
    DUPLICATE_ATTRIB(out, first);
  }
}

/* Reconcile ------------------------------------------------------------ */

static SEXP reconcile_values(SEXP values, mismatch_t* mm);

static SEXP reconcile_identical(SEXP values, mismatch_t* mm) {
  R_xlen_t n = XLENGTH(values);
  SEXP first = VECTOR_ELT(values, 0);
  for (R_xlen_t k = 1; k < n; k++) {
    if (!identical(first, VECTOR_ELT(values, k))) {
      set_mismatch(mm, 1, (int) k + 1, STBL_RECONCILE_NO_REASON);
      return NULL;
    }
  }
  return first;
}

static SEXP reconcile_atomics(SEXP values, mismatch_t* mm) {
  R_xlen_t n = XLENGTH(values);
  int reason;
  for (R_xlen_t i = 0; i < n - 1; i++) {
    for (R_xlen_t j = i + 1; j < n; j++) {
      if (!atomics_equivalent(VECTOR_ELT(values, i), VECTOR_ELT(values, j), &reason)) {
        set_mismatch(mm, (int) i + 1, (int) j + 1, reason);
        return NULL;
      }
    }
  }
  /* The narrowest type wins, and the first of equals. Types outside the
   * ranking are only equivalent to each other, so any will do. */
  R_xlen_t best = 0;
  int best_rank = 0;
  for (R_xlen_t i = 0; i < n; i++) {
    int rank = atomic_type(VECTOR_ELT(values, i));
    if (rank == T_NONE) rank = T_FCT;
    if (i == 0 || rank < best_rank) {
      best = i;
      best_rank = rank;
    }
  }
  return VECTOR_ELT(values, best);
}

static SEXP reconcile_lists(SEXP values, int is_df, mismatch_t* mm) {
  R_xlen_t n = XLENGTH(values);
  SEXP first = VECTOR_ELT(values, 0);
  for (R_xlen_t k = 1; k < n; k++) {
    int reason = container_difference(first, VECTOR_ELT(values, k), is_df);
    if (reason != STBL_RECONCILE_NO_REASON) {
      set_mismatch(mm, 1, (int) k + 1, reason);
      return NULL;
    }
  }

  R_xlen_t len = Rf_length(first);
  SEXP out = PROTECT(Rf_allocVector(VECSXP, len));
  /* One vector of the i-th elements, reused for every i. Nothing keeps it. */
  SEXP sub = PROTECT(Rf_allocVector(VECSXP, n));
  for (R_xlen_t i = 0; i < len; i++) {
    for (R_xlen_t k = 0; k < n; k++) {
      SET_VECTOR_ELT(sub, k, list_elt(VECTOR_ELT(values, k), i));
    }
    SEXP element = reconcile_values(sub, mm);
    if (element == NULL) {
      push_at(mm, i + 1);
      UNPROTECT(2);
      return NULL;
    }
    SET_VECTOR_ELT(out, i, element);
  }
  copy_container_attributes(first, out);
  UNPROTECT(2);
  return out;
}

/* Returns the reconciled value, or NULL (after filling `mm`) if the values
 * are not equivalent. The result is not protected. */
static SEXP reconcile_values(SEXP values, mismatch_t* mm) {
  R_xlen_t n = XLENGTH(values);
  SEXP first = VECTOR_ELT(values, 0);
  if (n == 1) return first;

  int first_category = category(first);
  for (R_xlen_t k = 1; k < n; k++) {
    if (category(VECTOR_ELT(values, k)) != first_category) {
      set_mismatch(mm, 1, (int) k + 1, STBL_RECONCILE_NO_REASON);
      return NULL;
    }
  }

  switch (first_category) {
    case C_ATOMIC:     return reconcile_atomics(values, mm);
    case C_LIST:       return reconcile_lists(values, 0, mm);
    case C_DATA_FRAME: return reconcile_lists(values, 1, mm);
    default:           return reconcile_identical(values, mm);
  }
}

static SEXP named_list2(const char* name1, SEXP v1, const char* name2, SEXP v2) {
  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_VECTOR_ELT(out, 0, v1);
  SET_VECTOR_ELT(out, 1, v2);
  SET_STRING_ELT(names, 0, Rf_mkChar(name1));
  SET_STRING_ELT(names, 1, Rf_mkChar(name2));
  Rf_setAttrib(out, R_NamesSymbol, names);
  UNPROTECT(2);
  return out;
}

SEXP stbl_reconcile(SEXP values) {
  if (TYPEOF(values) != VECSXP || XLENGTH(values) < 1) {
    Rf_error("`values` must be a list with at least one element.");
  }

  mismatch_t mm = {0, 0, 0, NULL, 0, 0};
  SEXP result = reconcile_values(values, &mm);
  if (result != NULL) {
    PROTECT(result);
    SEXP out = named_list2("result", result, "mismatch", R_NilValue);
    UNPROTECT(1);
    return out;
  }

  const char* fields[] = {"i", "j", "at", "reason"};
  SEXP details = PROTECT(Rf_allocVector(VECSXP, 4));
  SEXP details_names = PROTECT(Rf_allocVector(STRSXP, 4));
  for (int f = 0; f < 4; f++) {
    SET_STRING_ELT(details_names, f, Rf_mkChar(fields[f]));
  }
  Rf_setAttrib(details, R_NamesSymbol, details_names);
  SET_VECTOR_ELT(details, 0, Rf_ScalarInteger(mm.i));
  SET_VECTOR_ELT(details, 1, Rf_ScalarInteger(mm.j));
  SEXP at = Rf_allocVector(INTSXP, mm.n_at);
  SET_VECTOR_ELT(details, 2, at);
  /* Collected leaf first, reported from the top. */
  for (R_xlen_t k = 0; k < mm.n_at; k++) {
    INTEGER(at)[k] = (int) mm.at[mm.n_at - 1 - k];
  }
  SET_VECTOR_ELT(details, 3, Rf_ScalarInteger(mm.reason));
  SEXP out = named_list2("result", R_NilValue, "mismatch", details);
  UNPROTECT(2);
  return out;
}
