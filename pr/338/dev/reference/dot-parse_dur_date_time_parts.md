# Parse the regex captures from `to_dur.character()`'s date/time form

Parse the regex captures from
[`to_dur.character()`](https://stbl.wrangle.zone/dev/reference/to_dur.md)'s
date/time form

## Usage

``` r
.parse_dur_date_time_parts(matches)
```

## Arguments

- matches:

  `(list)` A list of character vectors, each the result of
  [`regmatches()`](https://rdrr.io/r/base/regmatches.html) on a single
  string that matched the RFC 3339 duration date/time pattern: the full
  match, followed by year, month, day, the whole `"T"`-prefixed time
  block, hour, minute, and second.

## Value

A list with numeric `year`, `month`, `day`, `hour`, `minute`, and
`second` components (each `0` where the corresponding piece was absent),
and a logical `valid` vector that is `FALSE` where the match does not
describe a real duration (such as `"P"` or `"PT"`, which have no
components at all).
