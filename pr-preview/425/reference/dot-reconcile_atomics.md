# Reconcile atomic vectors

Every pair must be equivalent. The result is the narrowest input.

## Usage

``` r
.reconcile_atomics(values, path)
```

## Arguments

- values:

  `(list)` At least one value.

- path:

  `(character(1))` The path to `values` within the original values, for
  messages.

## Value

The narrowest value, or a mismatch.
