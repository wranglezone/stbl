# Find extra named elements

Extra named elements are named, have no exact spec, and match no
pattern. When `named` is `NULL` or `FALSE`, names in `required` that
lack a spec are known (but unchecked), so they are not extra.

## Usage

``` r
.find_extra_named(.x, nms, spec_names, is_matched, named, required)
```

## Arguments

- .x:

  The object to stabilize.

- nms:

  `(character)` Result of `rlang::names2(.x)`.

- spec_names:

  `(character)` Names of the exact specs.

- is_matched:

  `(logical)` Element-wise indicator of elements matching any pattern.

- named:

  The `.named` argument.

- required:

  The normalized `.required` argument.

## Value

`(logical)` Element-wise indicator of extra named positions.
