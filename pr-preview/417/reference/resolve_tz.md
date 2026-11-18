# Resolve a time zone

Finds the time zone an object is displayed in, falling back to `default`
if the object doesn't name one (it lacks a `"tzone"` attribute, or that
attribute is `NA`, empty, or `""`).

## Usage

``` r
resolve_tz(x = NULL, default = Sys.timezone(), call = caller_env())
```

## Arguments

- x:

  An object, usually a
  [base::POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) or
  [base::POSIXlt](https://rdrr.io/r/base/DateTimeClasses.html) vector,
  whose `"tzone"` attribute should be used. The default, `NULL`, has no
  time zone, so `resolve_tz()` returns `default`.

- default:

  (`character(1)`) The time zone to use if `x` doesn't name one.
  Defaults to your local time zone, as reported by
  [`Sys.timezone()`](https://rdrr.io/r/base/timezones.html). As in
  [`to_dttm()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md),
  `""` is replaced by the name of your local time zone.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The name of a time zone from
[`OlsonNames()`](https://rdrr.io/r/base/timezones.html) as a character
string, or an error condition with classes `<stbl-error-bad_tz>`,
`<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
`<condition>` when the time zone cannot be determined or is not a value
from [`OlsonNames()`](https://rdrr.io/r/base/timezones.html).

## See also

Other datetime functions:
[`locale_datetime_formats()`](https://stbl.wrangle.zone/dev/reference/locale_datetime_formats.md),
[`specify_dttm()`](https://stbl.wrangle.zone/dev/reference/specify_dttm.md),
[`stabilize_dttm()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm.md),
[`stabilize_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm_scalar.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_dttm()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md),
[`to_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dttm_scalar.md)

## Examples

``` r
resolve_tz()
#> [1] "UTC"
resolve_tz(as.POSIXct("2024-01-01 12:00:00", tz = "America/Chicago"))
#> [1] "America/Chicago"
resolve_tz(Sys.time(), default = "UTC")
#> [1] "UTC"

# Keep the time zone of the input, using your local time zone if it has none.
x <- as.POSIXct("2024-01-01 12:00:00", tz = "Asia/Tokyo")
to_dttm(x, tz = resolve_tz(x))
#> [1] "2024-01-01 12:00:00 JST"
try(resolve_tz(default = "this is not a timezone"))
#> Error in eval(expr, envir) : 
#>   `default` must be "" or a value from `OlsonNames()`.
#> ✖ "this is not a timezone" is not a recognized time zone.
```
