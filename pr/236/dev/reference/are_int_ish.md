# Check if an object can be safely coerced to integer

`are_int_ish()` is a vectorized predicate function that checks whether
each element of its input can be safely coerced to an integer vector.
`are_integer_ish()` is a synonym of `are_int_ish()`.

`is_int_ish()` is a scalar predicate function that checks if all
elements of its input can be safely coerced to an integer vector.
`is_integer_ish()` is a synonym of `is_int_ish()`.

## Usage

``` r
are_int_ish(x, ...)

is_int_ish(x, ...)

are_integer_ish(x, ...)

is_integer_ish(x, ...)

# S3 method for class 'character'
are_int_ish(x, ..., coerce_character = TRUE)

# S3 method for class 'factor'
are_int_ish(x, ..., coerce_factor = TRUE)

# Default S3 method
are_int_ish(x, ..., depth = 1)
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

`are_int_ish()` returns a logical vector with the same length as the
input. `is_int_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`)
for the entire vector.

## See also

Other integer functions:
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md)

Other check functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
[`are_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md)

## Examples

``` r
are_int_ish(1:4)
#> [1] TRUE TRUE TRUE TRUE
is_int_ish(1:4)
#> [1] TRUE

are_int_ish(c(1.0, 2.0, 3.00000))
#> [1] TRUE TRUE TRUE
is_int_ish(c(1.0, 2.0, 3.00000))
#> [1] TRUE

are_int_ish(c("1.0", "2.0", "3.00000"))
#> [1] TRUE TRUE TRUE
is_int_ish(c("1.0", "2.0", "3.00000"))
#> [1] TRUE

are_int_ish(c(1, 2.2, NA))
#> [1]  TRUE FALSE  TRUE
is_int_ish(c(1, 2.2, NA))
#> [1] FALSE

are_int_ish(c("1", "1.0", "1.1", "a"))
#> [1]  TRUE  TRUE FALSE FALSE
is_int_ish(c("1", "1.0", "1.1", "a"))
#> [1] FALSE

are_int_ish(factor(c("1", "a")))
#> [1]  TRUE FALSE
is_int_ish(factor(c("1", "a")))
#> [1] FALSE
```
