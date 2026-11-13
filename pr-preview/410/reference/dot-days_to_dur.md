# Convert days to durations

Whole days go into the day component. Lubridate breaks any fractional
day into hours, minutes, and seconds, so `0.5` days is 12 hours.

## Usage

``` r
.days_to_dur(x)
```

## Arguments

- x:

  `(numeric)` Days.

## Value

A
[lubridate::Period](https://lubridate.tidyverse.org/reference/Period-class.html)
vector.
