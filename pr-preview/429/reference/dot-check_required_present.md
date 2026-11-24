# Check that required names are present

Check that required names are present

## Usage

``` r
.check_required_present(required, present, noun, x_arg, call)
```

## Arguments

- required:

  A canonical requirements list from
  [`.normalize_required()`](https://stbl.wrangle.zone/dev/reference/dot-normalize_required.md).

- present:

  `(character)` Names that are present.

- noun:

  (`character(1)`) What the names refer to, such as `"name"`,
  `"element"`, or `"column"`.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` invisibly (called for side effects).
