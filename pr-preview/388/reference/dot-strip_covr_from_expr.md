# Strip covr counter wrappers from an expression

covr instruments code for coverage by wrapping expressions in
`if (TRUE) { covr:::count(key); original }` blocks. This function
recursively removes those wrappers so that snapshotted code remains
stable across normal and coverage runs.

## Usage

``` r
.strip_covr_from_expr(expr)
```

## Arguments

- expr:

  An R expression (e.g. as returned by
  [`rlang::enexpr()`](https://rlang.r-lib.org/reference/defusing-advanced.html)).

## Value

The expression with all covr counter blocks removed.
