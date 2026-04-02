# Check that all elements of a spec list are named

Check that all elements of a spec list are named

## Usage

``` r
.check_specs_named(..., call = caller_env())
```

## Arguments

- ...:

  Spec functions forwarded from
  [`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md).

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if all elements are named.
