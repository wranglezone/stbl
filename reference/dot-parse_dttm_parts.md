# Parse the regex captures from `to_dttm.character()` into instants

Parse the regex captures from
[`to_dttm.character()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md)
into instants

## Usage

``` r
.parse_dttm_parts(matches)
```

## Arguments

- matches:

  `(list)` A list of character vectors, each the result of
  [`regmatches()`](https://rdrr.io/r/base/regmatches.html) on a single
  well-shaped RFC 3339 date-time string: the full match followed by
  year, month, day, hour, minute, second, optional fractional seconds,
  and the time zone offset.

## Value

A [base::POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) vector
(in UTC) the same length as `matches`, with `NA` at any position that
describes an impossible date-time (such as `"2024-02-30"`).
