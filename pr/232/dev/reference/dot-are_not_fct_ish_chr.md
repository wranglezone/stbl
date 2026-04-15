# Check for values that would be lost during factor coercion

Check for values that would be lost during factor coercion

## Usage

``` r
.are_not_fct_ish_chr(x, levels, to_na = character(), max_levels = Inf)
```

## Arguments

- x:

  The object to check.

- levels:

  `(character)` The desired factor levels.

- to_na:

  `(character)` Values to convert to `NA`.

- max_levels:

  `(length-1 numeric)` Maximum number of distinct non-`NA` values
  allowed across the whole vector after applying `to_na`.

## Value

A logical vector where `TRUE` indicates a failure.
