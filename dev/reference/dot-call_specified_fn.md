# Call a spec function with properly-named context arguments

Call a spec function with properly-named context arguments

## Usage

``` r
.call_specified_fn(spec_fn, .x, .x_arg, .call, .to_arg = NULL, .x_class = NULL)
```

## Arguments

- spec_fn:

  A stabilizer function.

- .x:

  The value to validate.

- .x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- .to_arg, .x_class:

  Optional `to_arg` and `x_class` values, passed on only when `spec_fn`
  accepts them and they are not `NULL`.

## Value

The validated value.
