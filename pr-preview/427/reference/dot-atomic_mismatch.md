# Compare two atomic vectors, for the C code

Called from C for pairs it doesn't compare itself.

## Usage

``` r
.atomic_mismatch(x, y)
```

## Arguments

- x, y:

  The values to compare.

## Value

`-1L` if `x` and `y` are equivalent. Otherwise the reason code of the
difference (see `.reconcile_reasons`), or `0L` for no specific reason.
