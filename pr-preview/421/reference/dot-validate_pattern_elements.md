# Validate elements whose names match `.patterns`

Elements matching several patterns (or an exact spec and a pattern) have
every spec applied to the original value, and the results are
reconciled. Failures are collected and reported together.

## Usage

``` r
.validate_pattern_elements(
  .x,
  nms,
  element_specs,
  patterns,
  matches,
  .x_arg,
  .call
)
```

## Arguments

- nms:

  `(character)` Result of `rlang::names2(.x)`.

- element_specs:

  `(list)` Named list of stabilizer functions, such as `stabilize_*`
  functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). Each name corresponds to an element in `.x`, and the function is
  used to validate that element when present. Whether the element is
  required is controlled by `.required`.

## Value

The updated list.
