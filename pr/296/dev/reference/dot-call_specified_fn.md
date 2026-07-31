# Call a spec function with properly-named context arguments

Call a spec function with properly-named context arguments

## Usage

``` r
.call_specified_fn(spec_fn, .x, .x_arg, .call)
```

## Arguments

- spec_fn:

  A stabilizer function.

- .x:

  The value to validate.

- .x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The validated value.
