# Parse the regex captures from `to_time.character()` into seconds

Parse the regex captures from
[`to_time.character()`](https://stbl.wrangle.zone/dev/reference/to_time.md)
into seconds

## Usage

``` r
.parse_time_parts(matches)
```

## Arguments

- matches:

  `(list)` A list of character vectors, each the result of
  [`regmatches()`](https://rdrr.io/r/base/regmatches.html) on a single
  well-shaped RFC 3339 `full-time` string: the full match followed by
  hour, minute, second, optional fractional seconds, and the
  time-offset.

## Value

A numeric vector the same length as `matches`, giving the UTC
time-of-day in seconds since midnight (always in `[0, 86400)`), or `NA`
at any position that describes an impossible time (such as
`"25:00:00Z"`).
