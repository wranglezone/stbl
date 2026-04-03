# Shared params for list helpers

Shared params for list helpers

## Arguments

- element_specs:

  `(list)` Named list of spec functions from `...`.

- is_extra_named:

  `(logical)` Element-wise indicator of extra named positions.

- named_spec:

  A spec function, or `NULL` to disallow extra named elements.

- nms:

  `(character)` Result of `rlang::names2(.x)`.
