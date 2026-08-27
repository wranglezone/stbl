# Coerce to date-time with additional checks

Compared to
[`to_dttm()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md),
`stabilize_dttm()` checks more details, but is slower.
`stabilise_dttm()`, `stabilize_datetime()`, `stabilise_dttm()`,
`stabilize_datetime()`, and `stabilise_datetime()` are synonyms of
`stabilize_dttm()`.

## Usage

``` r
stabilize_dttm(
  x,
  ...,
  tz = "UTC",
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_dttm(
  x,
  ...,
  tz = "UTC",
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_datetime(
  x,
  ...,
  tz = "UTC",
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_datetime(
  x,
  ...,
  tz = "UTC",
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL,
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

- tz:

  (`character(1)`) The time zone to normalize `x` to. Must be `""` or a
  value from [`OlsonNames()`](https://rdrr.io/r/base/timezones.html).
  Defaults to `"UTC"`.

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- allow_na:

  (`logical(1)`) Are NA values ok?

- min_size:

  (`integer(1)`) The minimum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- max_size:

  (`integer(1)`) The maximum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- unique:

  (`logical(1)`) Should all elements in `x` be distinct?

- min_value:

  (`numeric(1)`) The lowest allowed value for `x`. If `NULL` (default)
  values are not checked.

- max_value:

  (`numeric(1)`) The highest allowed value for `x`. If `NULL` (default)
  values are not checked.

- allowed_values:

  A vector of permitted values (coerced to the target type). `NULL`
  (default) skips the check. `NA` values in `x` are permitted
  independently of `allowed_values`, subject to `allow_na`.

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

The input as a
[base::POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) vector, or
an error condition with classes `<stbl-error>`, `<stbl-condition>`,
`<rlang_error>`, `<error>`, `<condition>`, and a specific class by
failure mode:

- `<stbl-error-coerce-datetime>` when `x` cannot be coerced to datetime.

- `<stbl-error-incompatible_values-datetime>` when some values cannot be
  safely converted to datetime.

- `<stbl-error-bad_tz>` when `tz` is not `""` or a value from
  [`OlsonNames()`](https://rdrr.io/r/base/timezones.html).

- `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.

- `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.

- `<stbl-error-size_too_small>` when the vector is shorter than
  `min_size`.

- `<stbl-error-size_too_large>` when the vector is longer than
  `max_size`.

- `<stbl-error-duplicate_elements>` when `unique = TRUE` and duplicates
  are present.

- `<stbl-error-outside_range>` when values fall outside `min_value` or
  `max_value`.

- `<stbl-error-allowed_values>` when values are not in `allowed_values`.

## See also

Other datetime functions:
[`specify_dttm()`](https://stbl.wrangle.zone/dev/reference/specify_dttm.md),
[`stabilize_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm_scalar.md),
[`to_dttm()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md),
[`to_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dttm_scalar.md)

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
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/to_int_scalar.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md),
[`to_time()`](https://stbl.wrangle.zone/dev/reference/to_time.md),
[`to_time_scalar()`](https://stbl.wrangle.zone/dev/reference/to_time_scalar.md)

## Examples

``` r
stabilize_dttm(as.POSIXct("2024-01-01 12:00:00", tz = "UTC"))
#> [1] "2024-01-01 12:00:00 UTC"
stabilize_dttm("2024-01-01T12:00:00Z")
#> [1] "2024-01-01 12:00:00 UTC"
stabilize_dttm(NULL)
#> NULL
try(stabilize_dttm(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
try(stabilize_dttm(
  c("2024-01-01T12:00:00Z", NA),
  allow_na = FALSE
))
#> Error in eval(expr, envir) : 
#>   `c("2024-01-01T12:00:00Z", NA)` must not contain NA values.
#> • NA locations: 2
try(stabilize_dttm("2024-01-01 12:00:00"))
#> Error in eval(expr, envir) : 
#>   `"2024-01-01 12:00:00"` <character> must be coercible to <datetime>
#> ✖ Can't convert some values due to invalid or ambiguous date-time format.
#> • Locations: 1
try(stabilize_dttm(
  "2024-01-01T12:00:00Z",
  min_value = "2024-06-01T00:00:00Z"
))
#> Error in eval(expr, envir) : 
#>   `"2024-01-01T12:00:00Z"` must be >= 2024-06-01 UTC.
#> ✖ "2024-01-01 12:00:00 UTC" is too low.
try(stabilize_dttm(
  "2024-12-01T00:00:00Z",
  max_value = "2024-06-01T00:00:00Z"
))
#> Error in eval(expr, envir) : 
#>   `"2024-12-01T00:00:00Z"` must be <= 2024-06-01 UTC.
#> ✖ "2024-12-01 UTC" is too high.
```
