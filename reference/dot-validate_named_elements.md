# Validate all named elements (required and extra)

Computes element name metadata and delegates to
[`.validate_required_elements()`](https://stbl.wrangle.zone/reference/dot-validate_required_elements.md)
and
[`.validate_extra_named_elements()`](https://stbl.wrangle.zone/reference/dot-validate_extra_named_elements.md).

## Usage

``` r
.validate_named_elements(
  .x,
  ...,
  .named,
  .allow_duplicate_names,
  .x_arg,
  .call
)
```

## Arguments

- .x:

  The argument to stabilize.

- ...:

  Named stabilizer functions, such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/reference/specify_chr.md),
  etc). Each name corresponds to a required element in `.x`, and the
  function is used to validate that element.

- .named:

  A single stabilizer function, such as a `stabilize_*` function
  ([`stabilize_chr()`](https://stbl.wrangle.zone/reference/stabilize_chr.md),
  etc) or a function produced by a `specify_*()` function
  ([`specify_chr()`](https://stbl.wrangle.zone/reference/specify_chr.md),
  etc). This function is used to validate all named elements of `.x`
  that are *not* explicitly listed in `...`. If `NULL` (default), any
  extra named elements will cause an error.

- .allow_duplicate_names:

  `(length-1 logical)` Should `.x` be allowed to have duplicate names?
  If `FALSE` (default), an error is thrown when any named element of
  `.x` shares a name with another.

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
