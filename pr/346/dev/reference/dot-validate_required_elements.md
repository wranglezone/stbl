# Validate required named elements against their spec functions

Validate required named elements against their spec functions

## Usage

``` r
.validate_required_elements(.x, element_specs, nms, .required, .x_arg, .call)
```

## Arguments

- .x:

  The object to stabilize.

- element_specs:

  `(list)` Named list of stabilizer functions, such as `stabilize_*`
  functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). Each name corresponds to an element in `.x`, and the function is
  used to validate that element when present. Whether the element is
  required is controlled by `.required`.

- nms:

  `(character)` Result of `rlang::names2(.x)`.

- .required:

  `(character)` Names (from `...`) of elements that must be present in
  `.x`. Defaults to all names in `...`, so every named spec is required
  unless you opt it out. Named specs *not* listed here are optional: if
  absent, no error is raised; if present, they're validated normally.
  Pass `NULL` or [`character()`](https://rdrr.io/r/base/character.html)
  to make every named spec optional. A zero-length `.x` (such as
  [`list()`](https://rdrr.io/r/base/list.html)) skips this check when
  `.allow_zero_length = TRUE` (the default); see `allow_zero_length`.

- .x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The updated list.
