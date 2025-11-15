# Coerce specified values to NA

A helper that converts specified values in `x` to `NA`.

## Usage

``` r
.coerce_fct_to_na(x, to_na = character(), call = caller_env())
```

## Arguments

- x:

  The argument to stabilize.

- to_na:

  `(character)` Values to convert to `NA`.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`x` with specified values converted to `NA`.
