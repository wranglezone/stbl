# Apply each positional spec, collecting every failure

Apply each positional spec, collecting every failure

## Usage

``` r
.validate_positional_elements(.x, specs, additional, x_arg, x_class, call)
```

## Arguments

- .x:

  The object to stabilize.

- specs:

  `(list)` The positional specs.

- additional:

  The `.additional` argument.

- x_arg:

  `(character(1))` The name of `.x`, for error messages.

- x_class:

  `(character)` The class of `.x`, for error messages.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The updated list.
