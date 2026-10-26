# Define the main message for a coercion failure that names both sides

Define the main message for a coercion failure that names both sides

## Usage

``` r
.cant_coerce_msg(from_class, to_class, x_arg, to_arg)
```

## Arguments

- from_class:

  (`character(1)`) The class of the object being coerced.

- to_class:

  (`character(1)`) The class being coerced to.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- to_arg:

  (`character(1)`) The name of the coercion target, already checked with
  [`.check_to_arg()`](https://stbl.wrangle.zone/dev/reference/dot-check_to_arg.md).

## Value

A character string.
