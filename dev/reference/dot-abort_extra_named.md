# Abort because extra named elements are not allowed

Abort because extra named elements are not allowed

## Usage

``` r
.abort_extra_named(extra_names, .x_arg, .call)
```

## Arguments

- extra_names:

  `(character)` Names of the extra elements.

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
