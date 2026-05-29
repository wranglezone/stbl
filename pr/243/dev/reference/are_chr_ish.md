# Check if an object can be safely coerced to character

`are_chr_ish()` is a vectorized predicate function that checks whether
each element of its input can be safely coerced to a character vector.
`are_character_ish()` is a synonym of `are_chr_ish()`.

`is_chr_ish()` is a scalar predicate function that checks if all
elements of its input can be safely coerced to a character vector.
`is_character_ish()` is a synonym of `is_chr_ish()`.

## Usage

``` r
are_chr_ish(x, ...)

is_chr_ish(x, ...)

are_character_ish(x, ...)

is_character_ish(x, ...)

# Default S3 method
are_chr_ish(x, ..., depth = 1)
```

## Arguments

- x:

  The object to check.

- ...:

  Arguments passed to methods.

- depth:

  `(length-1 integer)` Current recursion depth. Do not manually set this
  parameter.

## Value

`are_chr_ish()` returns a logical vector with the same length as the
input. `is_chr_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`)
for the entire vector.

## See also

Other character functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)

Other check functions:
[`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
[`are_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
[`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md)

## Examples

``` r
are_chr_ish(letters)
#>  [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
#> [16] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
is_chr_ish(letters)
#> [1] TRUE

are_chr_ish(1:10)
#>  [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
is_chr_ish(1:10)
#> [1] TRUE

are_chr_ish(list("a", 1, TRUE))
#> [1] TRUE TRUE TRUE
is_chr_ish(list("a", 1, TRUE))
#> [1] TRUE

are_chr_ish(list("a", 1, list(1, 2)))
#> [1]  TRUE  TRUE FALSE
is_chr_ish(list("a", 1, list(1, 2)))
#> [1] FALSE
```
