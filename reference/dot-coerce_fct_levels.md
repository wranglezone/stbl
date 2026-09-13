# Coerce to factor with specified levels

Coerce to factor with specified levels

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

  The object to stabilize.

- levels:

  `(character)` The desired factor levels. For factors, a vector's
  `levels` play the same role that `allowed_values` plays for other
  types: they restrict `x` to a fixed set of permitted values.

- to_na:

  `(character)` Values to convert to `NA`.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`x` as a factor with specified levels and NAs.
