# Validate all named elements (required and extra)

Computes element name metadata and delegates to
[`.validate_required_elements()`](https://stbl.wrangle.zone/dev/reference/dot-validate_required_elements.md)
and
[`.validate_extra_named_elements()`](https://stbl.wrangle.zone/dev/reference/dot-validate_extra_named_elements.md).

## Usage

``` r
.validate_named_elements(.x, ..., .named, .allow_duplicate_names, x_arg, call)
```

## Arguments

- .x:

  `(list)` The list being validated.

- ...:

  Named spec functions for required elements (forwarded from
  [`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md)).

- .named:

  A single
  [`specify_*()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md)
  function to validate all named elements of `.x` that are *not*
  explicitly listed in `...`. If `NULL` (default), any extra named
  elements will cause an error.

- .allow_duplicate_names:

  `(length-1 logical)` Should `.x` be allowed to have duplicate names?
  If `FALSE` (default), an error is thrown when any named element of
  `.x` shares a name with another.

- x_arg:

  `(length-1 character)` An argument name for `.x`. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The updated list.
