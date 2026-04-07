#include <R.h>
#include <Rinternals.h>
#include <R_ext/Arith.h>
#include <R_ext/Complex.h>

/*
 * Core single-pass complex-to-double checker/converter.
 *
 * A complex value is dbl-ish iff it is NA or its imaginary part is zero.
 * NA_complex_ has both parts as NaN; we treat any element with ISNAN(r) or
 * ISNAN(i) as NA (matching R's is.na() for complex).
 *
 * Fills p_result[0..n-1] and p_valid[0..n-1]:
 *   p_result: the converted double values (Re(x), NA_REAL where NA)
 *   p_valid:  1 for dbl-ish elements, 0 for elements with Im != 0
 */
static void cpx_to_dbl_core(SEXP x, R_xlen_t n,
                              double* p_result, int* p_valid) {
  Rcomplex* px = COMPLEX(x);
  for (R_xlen_t i = 0; i < n; i++) {
    double r = px[i].r;
    double im = px[i].i;

    if (ISNAN(r) || ISNAN(im)) {
      /* NA complex -> NA_REAL, valid (NA is dbl-ish) */
      p_result[i] = NA_REAL;
      p_valid[i]  = 1;
      continue;
    }

    if (im != 0.0) {
      /* Non-zero imaginary part: not dbl-ish */
      p_result[i] = r; /* return real part (matches as.double() behaviour) */
      p_valid[i]  = 0;
      continue;
    }

    p_result[i] = r;
    p_valid[i]  = 1;
  }
}

/*
 * ffi_cpx_to_dbl: internal FFI entry point used by stbl itself.
 *
 * Returns a named list of two vectors of length(x):
 *   $result: double — the converted values (NA_real_ for NA inputs)
 *   $valid:  logical — TRUE for elements that are dbl-ish (Im == 0 or NA)
 */
SEXP ffi_cpx_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  cpx_to_dbl_core(x, n, REAL(result), LOGICAL(valid));

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
 * stbl_cpx_to_dbl: public API entry point.
 *
 * Returns a double vector of length(x) with the real parts (NA_real_ for NA
 * inputs). No error is raised; elements with Im != 0 still return Re(x).
 */
SEXP stbl_cpx_to_dbl(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  cpx_to_dbl_core(x, n, REAL(result), LOGICAL(valid));
  UNPROTECT(2);
  return result;
}

/*
 * stbl_cpx_are_dblish: public API entry point.
 *
 * Returns a logical vector of length(x) that is TRUE for elements that are
 * NA or have Im == 0, FALSE otherwise.
 */
SEXP stbl_cpx_are_dblish(SEXP x) {
  R_xlen_t n = XLENGTH(x);
  SEXP result = PROTECT(Rf_allocVector(REALSXP, n));
  SEXP valid  = PROTECT(Rf_allocVector(LGLSXP, n));
  cpx_to_dbl_core(x, n, REAL(result), LOGICAL(valid));
  UNPROTECT(2);
  return valid;
}
