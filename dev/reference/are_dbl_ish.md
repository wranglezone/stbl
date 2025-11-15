# Check if an object can be safely coerced to double

`are_dbl_ish()` is a vectorized predicate function that checks whether
each element of its input can be safely coerced to a double vector.
`are_double_ish()` is a synonym of `are_dbl_ish()`.

`is_dbl_ish()` is a scalar predicate function that checks if all
elements of its input can be safely coerced to a double vector.
`is_double_ish()` is a synonym of `is_dbl_ish()`.

## Usage

``` r
are_dbl_ish(x, ...)

is_dbl_ish(x, ...)

are_double_ish(x, ...)

is_double_ish(x, ...)

# S3 method for class 'character'
are_dbl_ish(x, ..., coerce_character = TRUE)

# S3 method for class 'factor'
are_dbl_ish(x, ..., coerce_factor = TRUE)

# Default S3 method
are_dbl_ish(x, ..., depth = 1)
```

## Arguments

- x:

  The object to check.

- ...:

  Arguments passed to methods.

- coerce_character:

  `(length-1 logical)` Should character vectors such as "1" and "2.0" be
  considered numeric-ish?

- coerce_factor:

  `(length-1 logical)` Should factors with values such as "1" and "2.0"
  be considered numeric-ish? Note that this package uses the character
  value from the factor, while
  [`as.integer()`](https://rdrr.io/r/base/integer.html) and
  [`as.double()`](https://rdrr.io/r/base/double.html) use the integer
  index of the factor.

- depth:

  `(length-1 integer)` Current recursion depth. Do not manually set this
  parameter.

## Value

`are_dbl_ish()` returns a logical vector with the same length as the
input. `is_dbl_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`)
for the entire vector.

## See also

Other double functions:
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md)

Other check functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`are_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
[`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md)

## Examples

``` r
are_dbl_ish(c(1.0, 2.2, 3.14))
#> [1] TRUE TRUE TRUE
is_dbl_ish(c(1.0, 2.2, 3.14))
#> [1] TRUE

are_dbl_ish(1:3)
#> [1] TRUE TRUE TRUE
is_dbl_ish(1:3)
#> [1] TRUE

are_dbl_ish(c("1.1", "2.2", NA))
#> [1] TRUE TRUE TRUE
is_dbl_ish(c("1.1", "2.2", NA))
#> [1] TRUE

are_dbl_ish(c("a", "1.0"))
#> [1] FALSE  TRUE
is_dbl_ish(c("a", "1.0"))
#> [1] FALSE

are_dbl_ish(list(1, "2.2", "c"))
#> [1]  TRUE  TRUE FALSE
is_dbl_ish(list(1, "2.2", "c"))
#> [1] FALSE

are_dbl_ish(c(1 + 1i, 1 + 0i, NA))
#> [1] FALSE  TRUE  TRUE
is_dbl_ish(c(1 + 1i, 1 + 0i, NA))
#> [1] FALSE
```
