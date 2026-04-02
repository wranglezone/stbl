# Validate required named elements against their spec functions

For each name in `element_specs`, checks that the element exists in `.x`
and then applies its spec function in place.

## Usage

``` r
.validate_required_elements(.x, element_specs, nms, x_arg, call)
```

## Arguments

- .x:

  `(list)` The list being validated.

- element_specs:

  `(list)` Named list of spec functions from `...`.

- nms:

  `(character)` Result of `rlang::names2(.x)`.

- x_arg:

  `(length-1 character)` An argument name for `x`. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The updated list.
