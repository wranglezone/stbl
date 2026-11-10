# Validate or reject unnamed elements

Validate or reject unnamed elements

## Usage

``` r
.validate_unnamed_elements(.x, .unnamed, .x_arg, .call)
```

## Arguments

- .x:

  The object to stabilize.

- .unnamed:

  Controls how unnamed elements of `.x` are handled. One of:

  - `NULL` or `FALSE` (default): any unnamed elements cause an error.

  - `TRUE`: unnamed elements are allowed, unchecked.

  - A single stabilizer function, such as a `stabilize_*` function
    ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
    etc) or a function produced by a `specify_*()` function
    ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
    etc), used to validate every unnamed element.

- .x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The updated list.
