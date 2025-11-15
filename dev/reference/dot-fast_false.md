# Always return FALSE

A helper to force the slow path in
[`.to_cls_scalar()`](https://stbl.wrangle.zone/dev/reference/dot-to_cls_scalar.md)
for factors, since `rlang::is_scalar_factor()` does not exist.

## Usage

``` r
.fast_false(x)
```

## Arguments

- x:

  An object (ignored).

## Value

`FALSE`, always.
