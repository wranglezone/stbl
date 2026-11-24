# Signal an error when specs in stabilize_all_of() disagree

Signal an error when specs in stabilize_all_of() disagree

## Usage

``` r
.stop_inconsistent_all_of(x_arg, call)
```

## Arguments

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
