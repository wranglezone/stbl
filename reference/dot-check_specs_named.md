# Check that all elements of a spec list are named

Check that all elements of a spec list are named

## Usage

``` r
.check_specs_named(..., .call = caller_env())
```

## Arguments

- ...:

  Named stabilizer functions, such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/reference/specify_chr.md),
  etc). Each name corresponds to a required element in `.x`, and the
  function is used to validate that element.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if all elements are named.
