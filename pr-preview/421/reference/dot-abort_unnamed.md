# Abort because unnamed elements are not allowed

Abort because unnamed elements are not allowed

## Usage

``` r
.abort_unnamed(unnamed_positions, .x_arg, .call)
```

## Arguments

- unnamed_positions:

  `(integer)` Positions of the unnamed elements.

- .x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

Does not return; always signals an error.
