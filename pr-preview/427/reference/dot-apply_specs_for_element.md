# Apply one or more specs to a single element

With several specs, every spec is applied to the original value and the
results are reconciled.

## Usage

``` r
.apply_specs_for_element(specs, value, x_arg, call)
```

## Arguments

- specs:

  (`list`) Stabilizer functions to apply.

- value:

  (`any`) The element value.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The stabilized value.
