# Simplify a list of per-element results into a common-type vector

Combines `out` into an atomic vector when every element has size 1 and a
common type can be found; otherwise `out` is returned unchanged.

## Usage

``` r
.simplify_each(out, simplify)
```

## Arguments

- out:

  `(list)` Per-element results, such as produced by
  [`.map_each_fast()`](https://stbl.wrangle.zone/dev/reference/dot-map_each_fast.md)
  or the `out` element of
  [`.map_each_safe()`](https://stbl.wrangle.zone/dev/reference/dot-map_each_safe.md)'s
  result.

- simplify:

  (`logical(1)`) Should per-element results be combined into a single
  atomic vector when possible (every result has size 1 and shares a
  common type)? If `FALSE`, a list is always returned.

## Value

`out`, simplified to an atomic vector when possible.
