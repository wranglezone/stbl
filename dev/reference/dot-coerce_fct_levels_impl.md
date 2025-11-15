# Core implementation for applying factor levels

Checks for values in `x` that are not present in `levels` and throws an
error if any are found.

## Usage

``` r
.coerce_fct_levels_impl(
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

`x` as a factor with the specified levels.
