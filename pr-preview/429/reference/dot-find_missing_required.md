# Find the required names that are absent

Find the required names that are absent

## Usage

``` r
.find_missing_required(required, present, triggers = character())
```

## Arguments

- required:

  A canonical requirements list.

- present:

  `(character)` Names that are present.

- triggers:

  `(character)` The chain of triggers leading to `required`. Used for
  recursion.

## Value

A list with one entry per group of missing names. Each entry is a list
with elements `missing` (`character`) and `triggers` (`character`).
