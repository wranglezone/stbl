# Validate required named elements against their spec functions

Validate required named elements against their spec functions

## Usage

``` r
.validate_required_elements(.x, element_specs, nms, .x_arg, .call)
```

## Arguments

- .x:

  The argument to stabilize.

- element_specs:

  `(list)` Named list of stabilizer functions, such as `stabilize_*`
  functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). Each name corresponds to a required element in `.x`, and the
  function is used to validate that element.

- nms:

  `(character)` Result of `rlang::names2(.x)`.

- .x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The updated list.
