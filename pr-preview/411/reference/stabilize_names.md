# Ensure the names of an object meet expectations

Validate and optionally convert only the *names* of an object. The class
and values of `x` are left alone, so this is useful for objects (such as
S3 classes or factors) that you don't want to convert or check.
`stabilise_names()` is a synonym of `stabilize_names()`.

## Usage

``` r
stabilize_names(
  x,
  ...,
  allowed_names = NULL,
  spec = NULL,
  required = NULL,
  allow_duplicate_names = FALSE,
  x_arg = caller_arg(x),
  call = caller_env()
)

stabilise_names(
  x,
  ...,
  allowed_names = NULL,
  spec = NULL,
  required = NULL,
  allow_duplicate_names = FALSE,
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The object to stabilize.

- ...:

  Arguments passed to methods.

- allowed_names:

  `(character)` The permitted names. If supplied, `x` must be named
  (every element must have a non-empty name), and every name must be in
  this set. `NULL` (default), `NA`, or `character(0)` skip the check.

- spec:

  `(function)` A single stabilizer or conversion function, such as a
  `to_*` function
  ([`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
  etc.), a `stabilize_*` function
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc.), or a function produced by a `specify_*()` call
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc.). If supplied, `x` must be named (every element must have a
  non-empty name), and `spec` is applied to `names(x)`. The result
  becomes the names of the returned object. `NULL` (default) skips the
  check.

- required:

  `(character)` Names that must be present in `x` (after applying
  `spec`, if any). `NULL` (default) or
  [`character()`](https://rdrr.io/r/base/character.html) skip the check.

- allow_duplicate_names:

  (`logical(1)`) Should `x` be allowed to have duplicate names?

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`x` with stabilized names, or an error condition with classes
`<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
`<condition>`, and a specific class by failure mode:

- `<stbl-error-bad_named>` when `allowed_names` or `spec` is supplied
  and `x` is not fully named.

- `<stbl-error-allowed_names>` when a name is not in `allowed_names`.

- `<stbl-error-duplicate_names>` when duplicate names are present and
  `allow_duplicate_names = FALSE`.

- `<stbl-error-missing_element>` when a name in `required` is absent.

- Errors from `spec` when a name does not satisfy it.

## See also

Other names functions:
[`specify_names()`](https://stbl.wrangle.zone/dev/reference/specify_names.md)

Other stabilization functions:
[`assert_contains()`](https://stbl.wrangle.zone/dev/reference/assert_contains.md),
[`assert_not()`](https://stbl.wrangle.zone/dev/reference/assert_not.md),
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`stabilize_all_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_all_of.md),
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md),
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr_scalar.md),
[`stabilize_date()`](https://stbl.wrangle.zone/dev/reference/stabilize_date.md),
[`stabilize_date_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_date_scalar.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl_scalar.md),
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md),
[`stabilize_dttm()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm.md),
[`stabilize_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm_scalar.md),
[`stabilize_dur()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur.md),
[`stabilize_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur_scalar.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct_scalar.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md),
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`stabilize_lst_positional()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst_positional.md),
[`stabilize_one_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_one_of.md),
[`stabilize_time()`](https://stbl.wrangle.zone/dev/reference/stabilize_time.md),
[`stabilize_time_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_time_scalar.md),
[`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
[`to_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/to_chr_scalar.md),
[`to_date()`](https://stbl.wrangle.zone/dev/reference/to_date.md),
[`to_date_scalar()`](https://stbl.wrangle.zone/dev/reference/to_date_scalar.md),
[`to_dbl()`](https://stbl.wrangle.zone/dev/reference/to_dbl.md),
[`to_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dbl_scalar.md),
[`to_dttm()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md),
[`to_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dttm_scalar.md),
[`to_dur()`](https://stbl.wrangle.zone/dev/reference/to_dur.md),
[`to_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dur_scalar.md),
[`to_fct()`](https://stbl.wrangle.zone/dev/reference/to_fct.md),
[`to_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/to_fct_scalar.md),
[`to_int()`](https://stbl.wrangle.zone/dev/reference/to_int.md),
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/to_int_scalar.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md),
[`to_time()`](https://stbl.wrangle.zone/dev/reference/to_time.md),
[`to_time_scalar()`](https://stbl.wrangle.zone/dev/reference/to_time_scalar.md)

## Examples

``` r
# Names are checked, but the class and values are untouched
stabilize_names(c(a = 1, b = 2))
#> a b 
#> 1 2 

# Duplicate names are rejected by default
try(stabilize_names(c(a = 1, a = 2)))
#> Error in eval(expr, envir) : 
#>   `c(a = 1, a = 2)` must not contain duplicate names.
#> ✖ Duplicate name: "a"
stabilize_names(c(a = 1, a = 2), allow_duplicate_names = TRUE)
#> a a 
#> 1 2 

# Require specific names
try(stabilize_names(c(a = 1, b = 2), required = c("a", "c")))
#> Error in eval(expr, envir) : 
#>   `c(a = 1, b = 2)` must contain name "c".

# Restrict names to an allowed set
try(stabilize_names(c(a = 1, z = 2), allowed_names = c("a", "b")))
#> Error in eval(expr, envir) : 
#>   `c(a = 1, z = 2)` must have names from the allowed set.
#> ℹ Allowed names: "a" and "b".
#> ✖ Unexpected location: 2
#> ✖ Unexpected name: "z".

# Convert or validate the names with a spec
stabilize_names(c(a = 1, b = 2), spec = toupper)
#> A B 
#> 1 2 
try(stabilize_names(c(a = 1, B = 2), spec = specify_chr(regex = "^[a-z]$")))
#> Error in eval(expr, envir) : 
#>   `names(c(a = 1, B = 2))` must match the regex pattern "^[a-z]$"
#> ✖ Some values fail the check.
#> ✖ Location: 2
#> ✖ Value: B
```
