# Shared params for list helpers

Shared params for list helpers

## Arguments

- element_specs:

  `(list)` Named list of stabilizer functions, such as `stabilize_*`
  functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). Each name corresponds to a required element in `.x`, and the
  function is used to validate that element.

- is_extra_named:

  `(logical)` Element-wise indicator of extra named positions.

- named_spec:

  A single stabilizer function, such as a `stabilize_*` function
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or a function produced by a `specify_*()` function
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc), or `NULL` to disallow extra named elements.

- nms:

  `(character)` Result of `rlang::names2(.x)`.
