# Signal an error when a spec fails in stabilize_all_of()

Signal an error when a spec fails in stabilize_all_of()

## Usage

``` r
.stop_cant_stabilize_all_of(error, x_arg, call)
```

## Arguments

- error:

  `(error condition)` The error thrown by the failing spec.

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
