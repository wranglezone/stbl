# Build error messages for an unresolvable local time zone

The messages are cli templates, interpolated in the environment of
[`.stop_bad_tz()`](https://stbl.wrangle.zone/dev/reference/dot-stop_bad_tz.md)
(so they may refer to `tz` and `x_arg`).

## Usage

``` r
.bad_tz_msgs_local(tz)
```

## Arguments

- tz:

  (`character(1)`) The invalid time zone, possibly `NA`.

## Value

A list with elements `msg` and `additional_msg`.
