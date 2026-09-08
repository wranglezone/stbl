# Expand a date format into date and date-time variants

Expand a date format into date and date-time variants

## Usage

``` r
.datetime_format_variants(date_format)
```

## Arguments

- date_format:

  (`character(1)`) A
  [`strptime()`](https://rdrr.io/r/base/strptime.html)-style date
  format.

## Value

A [`character()`](https://rdrr.io/r/base/character.html) vector:
`date_format` with a `"T%H:%M:%S"` suffix (only when `date_format` is
`"%Y-%m-%d"`), with a `" %H:%M:%S"` suffix, and bare, in that order.
