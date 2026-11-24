# Reconcile a list of values

The comparison runs in C (`stbl_reconcile()`). Date, POSIXct, hms,
Period, and other classed values are compared in R by
[`.atomic_mismatch()`](https://stbl.wrangle.zone/dev/reference/dot-atomic_mismatch.md).

## Usage

``` r
.reconcile_values(values)
```

## Arguments

- values:

  `(list)` At least one value.

## Value

The reconciled value, or a mismatch (see
[`.new_mismatch()`](https://stbl.wrangle.zone/dev/reference/dot-new_mismatch.md)).
