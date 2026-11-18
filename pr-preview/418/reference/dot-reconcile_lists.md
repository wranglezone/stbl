# Reconcile lists or data frames element by element

Reconcile lists or data frames element by element

## Usage

``` r
.reconcile_lists(values, path, is_df = FALSE)
```

## Arguments

- values:

  `(list)` At least one value.

- path:

  `(character(1))` The path to `values` within the original values, for
  messages.

- is_df:

  `(logical(1))` Whether the values are data frames.

## Value

A list (or data frame) of reconciled elements, or a mismatch.
