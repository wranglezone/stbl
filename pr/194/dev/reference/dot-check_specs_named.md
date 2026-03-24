# Check that all elements of a spec list are named

Check that all elements of a spec list are named

## Usage

``` r
.check_specs_named(specs, call = caller_env())
```

## Arguments

- specs:

  `(list)` A named list of specification functions from `...`.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if all elements are named.
