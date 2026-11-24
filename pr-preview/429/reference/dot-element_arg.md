# Build the `x_arg` label for one element of a list

Uses the element name when unambiguous; falls back to position for
duplicated names.

## Usage

``` r
.element_arg(.x_arg, nm, position, is_ambiguous)
```

## Arguments

- .x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- nm:

  `(character(1))` The element's name.

- position:

  `(integer(1))` The element's position.

- is_ambiguous:

  `(logical(1))` Is `nm` shared with other elements?

## Value

`(character(1))` The label, such as `x[["a"]]` or `x[[2]]`.
