# Apply every function to x independently, requiring identical results

Applies each function in `fns` to the original `x`, independently.
Errors if any function fails, or if the successful results disagree.

## Usage

``` r
.apply_fns_requiring_consensus(x, fns, x_arg, call)
```

## Arguments

- x:

  The value to test.

- fns:

  `(list)` The list of stabilizer functions to apply.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The common result of applying every function in `fns` to `x`.
