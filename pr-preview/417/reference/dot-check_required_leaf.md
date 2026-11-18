# Check that a requirements leaf is a non-missing character vector

Check that a requirements leaf is a non-missing character vector

## Usage

``` r
.check_required_leaf(leaf, required_arg, call)
```

## Arguments

- leaf:

  The value to check.

- required_arg:

  (`character(1)`) Name of the argument, for error messages.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if the leaf is valid.
