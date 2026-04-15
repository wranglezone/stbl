# Check for values that would be lost during factor coercion

Check for values that would be lost during factor coercion

## Usage

``` r
.are_not_fct_ish_chr(x, levels, to_na = character())
```

## Arguments

- x:

  The object to check.

- levels:

  `(character)` The desired factor levels.

- to_na:

  `(character)` Values to convert to `NA`.

## Value

A logical vector where `TRUE` indicates a failure.
