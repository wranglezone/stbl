# Coerce to date

Checks whether a vector can be coerced to a
[base::Date](https://rdrr.io/r/base/Dates.html) without losing
information, returning it silently if so. Otherwise an informative error
message is signaled.

## Usage

``` r
to_date(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_date(x, ..., allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())

# S3 method for class 'character'
to_date(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'factor'
to_date(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'POSIXct'
to_date(x, ...)

# S3 method for class 'POSIXlt'
to_date(x, ...)

# S3 method for class 'numeric'
to_date(x, ...)

# S3 method for class 'integer'
to_date(x, ...)
```

## Arguments

- x:

  The object to stabilize.

- ...:

  Arguments passed to methods.

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

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

## Value

The input as a [base::Date](https://rdrr.io/r/base/Dates.html) vector.

## Details

Character vectors must use the [RFC
3339](https://datatracker.ietf.org/doc/html/rfc3339) `full-date` format
(`"YYYY-MM-DD"`); any other shape (such as `"11/13/2018"`) is rejected
(but see
[`stabilize_date()`](https://stbl.wrangle.zone/dev/reference/stabilize_date.md)).
`POSIXct` and `POSIXlt` values are truncated to their date component,
discarding the time-of-day and timezone offset. Numeric and integer
values are treated as the number of days since the Unix epoch
(`"1970-01-01"`).

## See also

Other date functions:
[`specify_date()`](https://stbl.wrangle.zone/dev/reference/specify_date.md),
[`stabilize_date()`](https://stbl.wrangle.zone/dev/reference/stabilize_date.md),
[`stabilize_date_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_date_scalar.md),
[`to_date_scalar()`](https://stbl.wrangle.zone/dev/reference/to_date_scalar.md)

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
to_date(as.Date("2024-01-01"))
#> [1] "2024-01-01"
to_date("2024-01-01")
#> [1] "2024-01-01"
to_date(c("2024-01-01", NA))
#> [1] "2024-01-01" NA          
to_date(0L)
#> [1] "1970-01-01"
to_date(as.POSIXct("2024-01-01 23:00:00", tz = "UTC"))
#> [1] "2024-01-01"
to_date(NULL)
#> NULL
try(to_date("11/13/2018"))
#> Error in eval(expr, envir) : 
#>   `"11/13/2018"` <character> must be coercible to <date>
#> ✖ Can't convert some values due to invalid or ambiguous date format.
#> • Locations: 1
try(to_date(c("2024-01-01", "not-a-date")))
#> Error in eval(expr, envir) : 
#>   `c("2024-01-01", "not-a-date")` <character> must be coercible to <date>
#> ✖ Can't convert some values due to invalid or ambiguous date format.
#> • Locations: 2
```
