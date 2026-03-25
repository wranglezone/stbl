# Coerce to factor with specified levels

A wrapper around level-coercion helpers.

## Usage

``` r
.coerce_fct_levels(
  x,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The argument to stabilize.

- levels:

  `(character)` The desired factor levels.

- to_na:

  `(character)` Values to convert to `NA`.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`x` as a factor with specified levels and NAs.
