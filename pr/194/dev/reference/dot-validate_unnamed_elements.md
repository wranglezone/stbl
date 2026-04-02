# Validate or reject unnamed elements

If unnamed elements exist and `unnamed_spec` is `NULL`, throws an error
reporting their positions. Otherwise applies `unnamed_spec` to each.

## Usage

``` r
.validate_unnamed_elements(.x, .unnamed, x_arg, call)
```

## Arguments

- .x:

  `(list)` The list being validated.

- .unnamed:

  A single
  [`specify_*()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md)
  function to validate all unnamed elements of `.x`. If `NULL`
  (default), any unnamed elements will cause an error.

- x_arg:

  `(length-1 character)` An argument name for `.x`. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The updated list.
