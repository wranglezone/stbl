# Check that one value is not greater than another

Check that one value is not greater than another

## Usage

``` r
.check_x_no_more_than_y(
  x,
  y,
  x_arg = caller_arg(x),
  y_arg = caller_arg(y),
  call = caller_env()
)
```

## Arguments

- x:

  The object to check.

- y:

  The value to compare against.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- y_arg:

  `(length-1 character)` The name of the `y` argument.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if `x` is not greater than `y`.
