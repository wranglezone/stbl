# Abort because elements matching `.patterns` failed their specs

Abort because elements matching `.patterns` failed their specs

## Usage

``` r
.stop_cant_stabilize_patterns(errors, locations, x_arg, call)
```

## Arguments

- errors:

  (`list`) Conditions caught while applying specs.

- locations:

  (`integer`) Positions of the failing elements.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

Does not return; always throws an error.
