# Check character values against character count constraints

Check character values against character count constraints

## Usage

``` r
.check_value_n_characters(
  x,
  min_characters = NULL,
  max_characters = NULL,
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The argument to stabilize.

- min_characters:

  (`integer(1)`) Minimum number of characters allowed in each element.

- max_characters:

  (`integer(1)`) Maximum number of characters allowed in each element.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if `x` passes all checks.
