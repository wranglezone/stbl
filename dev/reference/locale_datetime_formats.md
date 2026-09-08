# Determine locale-aware date and date-time formats

Returns an ordered set of
[`strptime()`](https://rdrr.io/r/base/strptime.html)-style format
strings, used as the default value of `accepted_datetime_formats` in
[`stabilize_date()`](https://stbl.wrangle.zone/dev/reference/stabilize_date.md),
[`stabilize_dttm()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm.md),
and their siblings. Character input is tried against each format in
turn, in order, until one of them parses every element (see those
functions for details).

## Usage

``` r
locale_datetime_formats(locale_time = Sys.getlocale("LC_TIME"))
```

## Arguments

- locale_time:

  (`character(1)`) `LC_TIME` locale, as returned by
  `Sys.getlocale("LC_TIME")`. Used to guess whether the locale's
  conventional date order is month-first (as in the United States) or
  day-first (most other locales); this is a coarse heuristic based on
  the locale string, not a full locale-aware calendar implementation.

## Value

A [`character()`](https://rdrr.io/r/base/character.html) vector of
[`strptime()`](https://rdrr.io/r/base/strptime.html)-style format
strings, always starting with `"%Y-%m-%dT%H:%M:%S"`,
`"%Y-%m-%d %H:%M:%S"`, and `"%Y-%m-%d"` (in that order), followed by the
locale's conventional day/month order with `"/"` and then `"-"`
separators (each listed with, then without, a `" %H:%M:%S"` suffix).

## See also

Other date functions:
[`specify_date()`](https://stbl.wrangle.zone/dev/reference/specify_date.md),
[`stabilize_date()`](https://stbl.wrangle.zone/dev/reference/stabilize_date.md),
[`stabilize_date_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_date_scalar.md),
[`to_date()`](https://stbl.wrangle.zone/dev/reference/to_date.md),
[`to_date_scalar()`](https://stbl.wrangle.zone/dev/reference/to_date_scalar.md)

Other datetime functions:
[`specify_dttm()`](https://stbl.wrangle.zone/dev/reference/specify_dttm.md),
[`stabilize_dttm()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm.md),
[`stabilize_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm_scalar.md),
[`to_dttm()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md),
[`to_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dttm_scalar.md)

## Examples

``` r
locale_datetime_formats("en_US.UTF-8")
#> [1] "%Y-%m-%dT%H:%M:%S" "%Y-%m-%d %H:%M:%S" "%Y-%m-%d"         
#> [4] "%m/%d/%Y %H:%M:%S" "%m/%d/%Y"          "%m-%d-%Y %H:%M:%S"
#> [7] "%m-%d-%Y"         
locale_datetime_formats("en_GB.UTF-8")
#> [1] "%Y-%m-%dT%H:%M:%S" "%Y-%m-%d %H:%M:%S" "%Y-%m-%d"         
#> [4] "%d/%m/%Y %H:%M:%S" "%d/%m/%Y"          "%d-%m-%Y %H:%M:%S"
#> [7] "%d-%m-%Y"         
```
