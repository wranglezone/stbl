# Check that all specs passed via ... are unnamed

Check that all specs passed via ... are unnamed

## Usage

``` r
.check_specs_unnamed(fns, .call = caller_env())
```

## Arguments

- fns:

  `(list)` The list of functions passed via `...`.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if all elements are unnamed.
