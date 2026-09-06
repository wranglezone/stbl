# Coerce to length-1 integer

Checks whether a vector can be coerced to a length-1 integer vector.
`to_integer_scalar()` is a synonym of `to_int_scalar()`.

## Usage

``` r
to_int_scalar(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_integer_scalar(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The object to stabilize.

- ...:

  Arguments passed to methods.

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- allow_zero_length:

  (`logical(1)`) Are zero-length vectors acceptable?

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its coercion, but want the error message to
  match the original class.

## Value

The input as a length-1 integer vector, or an error condition with
classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
`<condition>`, and a specific class by failure mode:

- `<stbl-error-coerce-integer>` when `x` cannot be coerced to integer.

- `<stbl-error-incompatible_values-integer>` when some values cannot be
  safely converted to integer.

- `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.

- `<stbl-error-bad_empty>` for empty vectors when
  `allow_zero_length = FALSE`.

- `<stbl-error-non_scalar>` for non-scalar vectors.

## See also

Other integer functions:
[`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_int()`](https://stbl.wrangle.zone/dev/reference/to_int.md)

Other stabilization functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
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
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md),
[`to_time()`](https://stbl.wrangle.zone/dev/reference/to_time.md),
[`to_time_scalar()`](https://stbl.wrangle.zone/dev/reference/to_time_scalar.md)

## Examples

``` r
to_int_scalar("1")
#> [1] 1
try(to_int_scalar(1:10))
#> Error in eval(expr, envir) : 
#>   `1:10` must be a single <integer>.
#> ✖ `1:10` has 10 values.
```
