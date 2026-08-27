# Check if an expression is a covr counter call

covr instruments code by wrapping expressions in
`if (TRUE) { covr:::count(key); original }` blocks. This checks whether
`expr` is the `covr:::count(key)` part.

## Usage

``` r
.is_covr_count_call(expr)
```

## Arguments

- expr:

  An R expression.

## Value

`TRUE` if `expr` is a covr counter call, `FALSE` otherwise.
