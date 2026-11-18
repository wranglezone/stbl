# Create a record of two values that can't be reconciled

Create a record of two values that can't be reconciled

## Usage

``` r
.new_mismatch(i, j, path, reason = NULL)
```

## Arguments

- i, j:

  `(integer(1))` The positions of the values that disagree.

- path:

  `(character(1))` The path within the values to the first difference.

- reason:

  `(character(1))` A description of the difference, or `NULL`.

## Value

A `stbl_mismatch` object.
