# Coerce to time-of-day

Checks whether a vector can be coerced to an
[`hms::hms()`](https://hms.tidyverse.org/reference/hms.html) time-of-day
vector without losing information, returning it silently if so.
Otherwise an informative error message is signaled.

## Usage

``` r
to_time(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_time(x, ..., allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())

# S3 method for class 'character'
to_time(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'factor'
to_time(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'POSIXct'
to_time(x, ..., call = caller_env())

# S3 method for class 'POSIXlt'
to_time(x, ..., call = caller_env())

# S3 method for class 'numeric'
to_time(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'integer'
to_time(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'difftime'
to_time(
  x,
  ...,
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

The input as an
[`hms::hms()`](https://hms.tidyverse.org/reference/hms.html) vector,
always expressed in UTC.

## Details

Character vectors must use the [RFC
3339](https://datatracker.ietf.org/doc/html/rfc3339) `full-time` format
(`"HH:MM:SS"`, optionally followed by fractional seconds and a mandatory
offset of either `"Z"` or a numeric offset such as `"+05:00"`); any
other shape is rejected. The offset is used only to normalize the value
to UTC and is not retained: `to_time()` always returns the time-of-day
expressed in UTC.
[base::POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) and
[base::POSIXlt](https://rdrr.io/r/base/DateTimeClasses.html) values are
likewise converted to UTC before their time-of-day component is
extracted. Numeric and
[base::difftime](https://rdrr.io/r/base/difftime.html) values are
treated as (fractional) seconds since midnight and must resolve to a
value in `[0, 86400)`.

`to_time()` requires the hms package.

## See also

Other time functions:
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md),
[`stabilize_time()`](https://stbl.wrangle.zone/dev/reference/stabilize_time.md),
[`stabilize_time_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_time_scalar.md),
[`to_time_scalar()`](https://stbl.wrangle.zone/dev/reference/to_time_scalar.md)

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
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/to_int_scalar.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md),
[`to_time_scalar()`](https://stbl.wrangle.zone/dev/reference/to_time_scalar.md)

## Examples

``` r
to_time(hms::hms(0, 20, 13))
#> 13:20:00
to_time("13:20:00Z")
#> 13:20:00
to_time("13:20:00-05:00")
#> 18:20:00
to_time(c("13:20:00Z", NA))
#> 13:20:00
#>       NA
to_time(3600)
#> 01:00:00
to_time(as.POSIXct("2024-01-01 13:20:00", tz = "UTC"))
#> 13:20:00
to_time(NULL)
#> NULL
try(to_time("13:20:00"))
#> Error in eval(expr, envir) : 
#>   `"13:20:00"` <character> must be coercible to <time>
#> ✖ Can't convert some values due to invalid or ambiguous time format.
#> • Locations: 1
try(to_time(c("13:20:00Z", "not-a-time")))
#> Error in eval(expr, envir) : 
#>   `c("13:20:00Z", "not-a-time")` <character> must be coercible to <time>
#> ✖ Can't convert some values due to invalid or ambiguous time format.
#> • Locations: 2
```
