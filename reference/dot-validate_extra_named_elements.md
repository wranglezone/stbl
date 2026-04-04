# Validate or reject extra named elements

Validate or reject extra named elements

## Usage

``` r
.validate_extra_named_elements(
  .x,
  nms,
  is_extra_named,
  named_spec,
  .x_arg,
  .call
)
```

## Arguments

- .x:

  The argument to stabilize.

- nms:

  `(character)` Result of `rlang::names2(.x)`.

- is_extra_named:

  `(logical)` Element-wise indicator of extra named positions.

- named_spec:

  A single stabilizer function, such as a `stabilize_*` function
  ([`stabilize_chr()`](https://stbl.wrangle.zone/reference/stabilize_chr.md),
  etc) or a function produced by a `specify_*()` function
  ([`specify_chr()`](https://stbl.wrangle.zone/reference/specify_chr.md),
  etc), or `NULL` to disallow extra named elements.

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
