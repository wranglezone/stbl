# Check that a specs list is non-empty

Check that a specs list is non-empty

## Usage

``` r
.check_specs_not_empty(fns, .call = caller_env())
```

## Arguments

- fns:

  `(list)` The list of functions or prototypes passed via `...`.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if the list is non-empty.
