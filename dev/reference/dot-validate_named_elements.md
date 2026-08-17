# Validate all named elements (required and extra)

Validate all named elements (required and extra)

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

  The object to stabilize.

- ...:

  Named stabilizer functions, such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). Each name corresponds to a required element in `.x`, and the
  function is used to validate that element.

- .named:

  Controls how named elements of `.x` that are *not* explicitly listed
  in `...` are handled. One of:

  - `NULL` or `FALSE` (default): any extra named elements cause an
    error.

  - `TRUE`: extra named elements are allowed, unchecked.

  - A single stabilizer function, such as a `stabilize_*` function
    ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
    etc) or a function produced by a `specify_*()` function
    ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
    etc), used to validate every extra named element.

- .allow_duplicate_names:

  (`logical(1)`) Should `.x` be allowed to have duplicate names? If
  `FALSE` (default), an error is thrown when any named element of `.x`
  shares a name with another.

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
