# Check names, required positions, and extra elements of a tuple

Check names, required positions, and extra elements of a tuple

## Usage

``` r
.check_positional_shape(.x, n_specs, n_required, additional, x_arg, call)
```

## Arguments

- .x:

  The object to stabilize.

- n_specs:

  `(integer(1))` The number of specs.

- n_required:

  `(integer(1))` The validated `.n_required`.

- additional:

  The `.additional` argument.

- x_arg:

  `(character(1))` The name of `.x`, for error messages.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if the checks pass.
