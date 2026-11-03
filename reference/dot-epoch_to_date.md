# Convert seconds or milliseconds since the Unix epoch to dates

Goes through
[`to_dttm()`](https://stbl.wrangle.zone/reference/to_dttm.md) and then
truncates to the UTC date, so calendar details are handled by base R
rather than by our own arithmetic.

## Usage

``` r
.epoch_to_date(
  x,
  tz,
  treat_number_as,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The object to stabilize.

- tz:

  (`character(1)`) The time zone to normalize `x` to. Must be a value
  from [`OlsonNames()`](https://rdrr.io/r/base/timezones.html) or `""`,
  which is replaced by the name of your local time zone (as reported by
  [`Sys.timezone()`](https://rdrr.io/r/base/timezones.html)) so that the
  result always names its time zone. To use the time zone of an existing
  object, or your local time zone if it doesn't have one, use
  `tz = resolve_tz(x)` (see
  [`resolve_tz()`](https://stbl.wrangle.zone/reference/resolve_tz.md)).

- treat_number_as:

  (`character(1)`) How to interpret numeric input: `"seconds"` or
  `"milliseconds"` since the Unix epoch, `"days"` since the Unix epoch,
  or `"error"` to reject numbers. Ignored for non-numeric input.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- to_arg:

  (`character(1)` or `NULL`) The name of the object that `x` is being
  converted to match, for use in error messages. When `NULL`, error
  messages describe only `x`. When supplied, conversion failure messages
  name both `x_arg` and `to_arg`.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its conversion, but want the error message to
  match the original class.

## Value

A [base::Date](https://rdrr.io/r/base/Dates.html) vector.
