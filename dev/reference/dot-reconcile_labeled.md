# Reconcile values that already have labels

Reconcile values that already have labels

## Usage

``` r
.reconcile_labeled(values, labels, call)
```

## Arguments

- values:

  `(list)` The values to reconcile.

- labels:

  `(character)` One label per element of `values`, for messages.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The reconciled value, or an error.
