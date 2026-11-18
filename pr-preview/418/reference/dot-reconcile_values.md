# Reconcile a list of values

Reconcile a list of values

## Usage

``` r
.reconcile_values(values, path = "")
```

## Arguments

- values:

  `(list)` At least one value.

- path:

  `(character(1))` The path to `values` within the original values, for
  messages.

## Value

The reconciled value, or a mismatch (see
[`.new_mismatch()`](https://stbl.wrangle.zone/dev/reference/dot-new_mismatch.md)).
