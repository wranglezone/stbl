# Validate or reject extra named elements

Extra named elements are those not listed in `...` (i.e.
`is_extra_named` is `TRUE`). If `named_spec` is `NULL`, throws an error
reporting their names. Otherwise applies `named_spec` to each.

## Usage

``` r
.validate_extra_named_elements(
  .x,
  nms,
  is_extra_named,
  named_spec,
  x_arg,
  call
)
```

## Arguments

- .x:

  `(list)` The list being validated.

- nms:

  `(character)` Result of `rlang::names2(.x)`.

- is_extra_named:

  `(logical)` Element-wise indicator of extra named positions.

- named_spec:

  A spec function, or `NULL` to disallow extra named elements.

- x_arg:

  `(length-1 character)` An argument name for `x`. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The updated list.
