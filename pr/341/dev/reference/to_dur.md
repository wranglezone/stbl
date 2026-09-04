# Coerce to a duration

Checks whether a vector can be coerced to a
[lubridate::Period](https://lubridate.tidyverse.org/reference/Period-class.html)
without losing information, returning it silently if so. Otherwise an
informative error message is signaled.

## Usage

``` r
to_dur(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_duration(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_dur(x, ..., allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())

# S3 method for class 'Period'
to_dur(x, ...)

# S3 method for class 'character'
to_dur(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'factor'
to_dur(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'difftime'
to_dur(x, ..., call = caller_env())

# S3 method for class 'numeric'
to_dur(x, ..., call = caller_env())

# S3 method for class 'integer'
to_dur(x, ..., call = caller_env())
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

The input as a
[lubridate::Period](https://lubridate.tidyverse.org/reference/Period-class.html)
vector, or an error condition with classes `<stbl-error>`,
`<stbl-condition>`, `<rlang_error>`, `<error>`, `<condition>`, and a
specific class by failure mode:

- `<stbl-error-incompatible_values-duration>` when some values cannot be
  safely converted to a duration.

- `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.

## Details

`Period` is chosen as the target class because it preserves the calendar
components (years, months, days, hours, minutes, seconds) of an [RFC
3339](https://datatracker.ietf.org/doc/html/rfc3339) / [ISO
8601](https://en.wikipedia.org/wiki/ISO_8601) duration string
separately, rather than collapsing them into a single number of seconds.
That fidelity comes at a cost: years and months have no fixed length, so
comparisons (`min_value`, `max_value`, `allowed_values` in
[`stabilize_dur()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur.md))
use lubridate's approximate, nominal lengths (a 365.25-day year, a
30.4375-day month) and may not reflect the actual elapsed time implied
by a specific calendar date.

Character vectors must use the [RFC
3339](https://datatracker.ietf.org/doc/html/rfc3339) `duration` format:
`"P"` followed by an optional number of years (`Y`), months (`M`), and
days (`D`), then an optional `"T"`-prefixed block of hours (`H`),
minutes (`M`), and seconds (`S`) (for example `"P3Y6M4DT12H30M5S"`,
`"P23DT23H"`, or `"PT1M"`); or a stand-alone week form (`"P4W"`). The
date/time form and the week form cannot be mixed, fractional components
are not permitted, and `"P"` or `"PT"` alone (with no components) are
not valid durations.
[base::difftime](https://rdrr.io/r/base/difftime.html) values (including
[`hms::hms()`](https://hms.tidyverse.org/reference/hms.html)) are
converted directly, preserving their unit. Numeric and integer values
are treated as a (fractional) number of seconds and broken into
day/hour/minute/second components, with no year or month component,
since a number of seconds cannot unambiguously imply a calendar length.

`to_dur()` requires the lubridate package.

## See also

Other duration functions:
[`specify_dur()`](https://stbl.wrangle.zone/dev/reference/specify_dur.md),
[`stabilize_dur()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur.md),
[`stabilize_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur_scalar.md),
[`to_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dur_scalar.md)

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
to_dur(lubridate::period(year = 1, month = 2, day = 3))
#> [1] "1y 2m 3d 0H 0M 0S"
to_dur("P3Y6M4DT12H30M5S")
#> [1] "3y 6m 4d 12H 30M 5S"
to_dur("PT1M")
#> [1] "1M 0S"
to_dur("P4W")
#> [1] "28d 0H 0M 0S"
to_dur(c("P1D", NA))
#> [1] "1d 0H 0M 0S" NA           
to_dur(3661)
#> [1] "1H 1M 1S"
to_dur(as.difftime(90, units = "mins"))
#> [1] "1H 30M 0S"
to_dur(NULL)
#> NULL
try(to_dur("P"))
#> Error in eval(expr, envir) : 
#>   `"P"` <character> must be coercible to <duration>
#> ✖ Can't convert some values due to invalid or ambiguous duration format.
#> • Locations: 1
#> • Values: "P"
try(to_dur(c("P1D", "not-a-duration")))
#> Error in eval(expr, envir) : 
#>   `c("P1D", "not-a-duration")` <character> must be coercible to <duration>
#> ✖ Can't convert some values due to invalid or ambiguous duration format.
#> • Locations: 2
#> • Values: "not-a-duration"
```
