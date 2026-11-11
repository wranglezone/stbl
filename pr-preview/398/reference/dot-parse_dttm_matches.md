# Parse capture-group matches from `.try_dttm_formats()` into instants

Parse capture-group matches from
[`.try_dttm_formats()`](https://stbl.wrangle.zone/dev/reference/dot-try_dttm_formats.md)
into instants

## Usage

``` r
.parse_dttm_matches(matches, fields, tz)
```

## Arguments

- matches:

  `(list)` Regex captures from
  [`regmatches()`](https://rdrr.io/r/base/regmatches.html): the full
  match, one group per calendar field named in `fields`, and a trailing
  UTC-offset group (possibly `""` when absent).

- fields:

  `(character)` Which calendar field (`"Y"`, `"m"`, `"d"`, `"H"`, `"M"`,
  or `"S"`) each non-offset capture group corresponds to, in the order
  the groups appear.

- tz:

  `(character(1))` The time zone to assume for elements with no explicit
  offset.

## Value

A [base::POSIXct](https://rdrr.io/r/base/DateTimeClasses.html) vector
(in `tz`), the same length as `matches`, with `NA` at any position that
describes an impossible date-time (such as `"2024-02-30"`).
