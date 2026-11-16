# Signal an error when values can't be reconciled

Signal an error when values can't be reconciled

## Usage

``` r
.stop_cant_reconcile(mismatch, labels, call)
```

## Arguments

- mismatch:

  A `stbl_mismatch` object.

- labels:

  `(character)` The labels of the values.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

Does not return; throws an error.
