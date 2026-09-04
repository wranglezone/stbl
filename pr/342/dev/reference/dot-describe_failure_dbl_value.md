# Describe a numeric value validation failure

Describe a numeric value validation failure

## Usage

``` r
.describe_failure_dbl_value(
  x,
  failure_locations,
  direction,
  target_value,
  x_arg,
  exclusive = FALSE
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

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- exclusive:

  `(logical(1))` Is this an exclusive (strict) bound? When `TRUE`,
  values equal to `target_value` fail the check, and the comparison
  operator in the error message omits `=`.

## Value

A named character vector for
[`.stbl_abort()`](https://stbl.wrangle.zone/dev/reference/dot-stbl_abort.md).
