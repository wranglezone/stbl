# Check double values against min and max values

Check double values against min and max values

## Usage

``` r
.check_value_dbl(
  x,
  min_value,
  max_value,
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The argument to stabilize.

- min_value:

  `(length-1 numeric)` The lowest allowed value for `x`. If `NULL`
  (default) values are not checked.

- max_value:

  `(length-1 numeric)` The highest allowed value for `x`. If `NULL`
  (default) values are not checked.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if `x` passes all checks.
