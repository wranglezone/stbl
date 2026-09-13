# Signal a combined error when no function succeeds

Signal a combined error when no function succeeds

## Usage

``` r
.stop_cant_stabilize_any_of(errors, x_arg, call)
```

## Arguments

- errors:

  `(list)` List of error conditions from failed attempts.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

Does not return; throws an error.
