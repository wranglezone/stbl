# Try candidate date-time formats against a character vector

Like
[`.try_date_formats()`](https://stbl.wrangle.zone/dev/reference/dot-try_date_formats.md),
but for date-time strings, with an optional trailing UTC offset (`"Z"`
or a numeric offset such as `"+05:00"`). Elements with an offset are
converted using that offset; elements without one are treated as
wall-clock time in `tz`.

## Usage

``` r
.try_dttm_formats(x, formats, tz)
```

## Arguments

- x:

  `(character)` The vector to parse.

- formats:

  `(character)` Candidate
  [`strptime()`](https://rdrr.io/r/base/strptime.html)-style format
  strings, tried in order.

- tz:

  `(character(1))` The time zone to assume for date-times with no
  explicit offset, and to attach to the result.

## Value

A list with `parsed` (a
[base::POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) vector, in
`tz`) and `failures` (a logical vector, the same length as `x`).
