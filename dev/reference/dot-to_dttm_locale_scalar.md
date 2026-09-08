# Coerce to length-1 date-time, trying `accepted_datetime_formats`

The scalar counterpart of
[`.to_dttm_locale()`](https://stbl.wrangle.zone/dev/reference/dot-to_dttm_locale.md),
used by
[`stabilize_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm_scalar.md)
in place of
[`to_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dttm_scalar.md).

## Usage

``` r
.to_dttm_locale_scalar(
  x,
  ...,
  tz,
  accepted_datetime_formats,
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

- tz:

  (`character(1)`) The time zone to normalize `x` to. Must be `""` or a
  value from [`OlsonNames()`](https://rdrr.io/r/base/timezones.html).
  Defaults to `"UTC"`.

- accepted_datetime_formats:

  (`character`)
  [`strptime()`](https://rdrr.io/r/base/strptime.html)-style format
  strings to try, in order, when parsing a character `x`. The first
  format that parses every non-`NA` element of `x` is used; if none do,
  the result (and any error) is based on the first format tried.
  Defaults to
  [`locale_datetime_formats()`](https://stbl.wrangle.zone/dev/reference/locale_datetime_formats.md),
  which starts with the unambiguous RFC 3339 shape (`"%Y-%m-%d"`,
  optionally with a time-of-day component) before falling back to the
  current locale's conventional date order.

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

The input as a length-1
[base::POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) vector.
