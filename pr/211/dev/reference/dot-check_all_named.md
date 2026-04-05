# Check that all list elements are named

Check that all list elements are named

## Usage

``` r
.check_all_named(x, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The argument to stabilize.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if all elements have names.
