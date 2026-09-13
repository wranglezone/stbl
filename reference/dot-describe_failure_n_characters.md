# Describe a character count validation failure

Describe a character count validation failure

## Usage

``` r
.describe_failure_n_characters(x, failure_locations, target, direction, x_arg)
```

## Arguments

- x:

  `(character)` The vector being checked.

- failure_locations:

  `(integer)` Indices where the check failed.

- target:

  (`integer(1)`) The character count limit.

- direction:

  (`character(1)`) One of `"few"` or `"many"`.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

## Value

A named character vector for
[`.stbl_abort()`](https://stbl.wrangle.zone/dev/reference/dot-stbl_abort.md).
