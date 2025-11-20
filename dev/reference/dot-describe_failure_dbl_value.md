# Describe a numeric value validation failure

Describe a numeric value validation failure

## Usage

``` r
.describe_failure_dbl_value(
  x,
  failure_locations,
  direction,
  target_value,
  x_arg
)
```

## Arguments

- x:

  `(numeric)` The vector being checked.

- failure_locations:

  `(integer)` Indices where the check failed.

- direction:

  `(character)` One of `"low"` or `"high"`.

- target_value:

  `(numeric)` The value against which `x` is being compared.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

## Value

A named character vector for
[`.stbl_abort()`](https://stbl.wrangle.zone/dev/reference/dot-stbl_abort.md).
