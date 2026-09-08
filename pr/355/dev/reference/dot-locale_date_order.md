# Guess a locale's conventional day/month order

Guess a locale's conventional day/month order

## Usage

``` r
.locale_date_order(locale_time)
```

## Arguments

- locale_time:

  (`character(1)`) The current `LC_TIME` locale, as returned by
  `Sys.getlocale("LC_TIME")`. Used only to guess whether the locale's
  conventional date order is month-first (as in the United States) or
  day-first (most other locales); this is a coarse heuristic based on
  the locale string, not a full locale-aware calendar implementation.

## Value

A length-2 character vector, either `c("m", "d")` (month before day) or
`c("d", "m")` (day before month).
