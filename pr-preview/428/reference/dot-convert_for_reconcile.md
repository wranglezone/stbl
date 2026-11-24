# Convert `x` to the type of `y`, independent of the session time zone

When going from a date-time to a Date, the date depends on the time
zone, so use the time zone of the date-time.

## Usage

``` r
.convert_for_reconcile(x, y)
```

## Arguments

- x, y:

  The values to compare.

## Value

`x` converted to the type of `y`.
