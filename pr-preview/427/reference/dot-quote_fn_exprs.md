# Expressions to capture a function's call-site name in a specified function

The generated function wraps `x`, so the stabilizer would otherwise see
the symbol `x` instead of what the user supplied. Functions are wrapped
in a quosure so the call-site expression is preserved.

## Usage

``` r
.quote_fn_exprs()
```

## Value

A list of expressions to run in the generated function.
