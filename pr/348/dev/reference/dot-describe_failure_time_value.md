# Describe a time-of-day value validation failure

Describe a time-of-day value validation failure

## Usage

``` r
.describe_failure_time_value(x, failures, direction, target_value, x_arg)
```

## Arguments

- x:

  `(hms)` The vector being checked.

- failures:

  `(logical)` Which elements failed the check.

- direction:

  `(character)` One of `"low"` or `"high"`.

- target_value:

  `(hms)` The value against which `x` is being compared.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

## Value

A named character vector for
[`.stbl_abort()`](https://stbl.wrangle.zone/dev/reference/dot-stbl_abort.md),
or `NULL`.
