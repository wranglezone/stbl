# Check if an object can be safely coerced to logical

`are_lgl_ish()` is a vectorized predicate function that checks whether
each element of its input can be safely coerced to a logical vector.
`are_logical_ish()` is a synonym of `are_lgl_ish()`.

`is_lgl_ish()` is a scalar predicate function that checks if all
elements of its input can be safely coerced to a logical vector.
`is_logical_ish()` is a synonym of `is_lgl_ish()`.

## Usage

``` r
are_lgl_ish(x, ...)

is_lgl_ish(x, ...)

are_logical_ish(x, ...)

is_logical_ish(x, ...)

# Default S3 method
are_lgl_ish(x, ..., depth = 1)
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

`are_lgl_ish()` returns a logical vector with the same length as the
input. `is_lgl_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`)
for the entire vector.

## See also

Other logical functions:
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)

Other check functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
[`are_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
[`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md)

## Examples

``` r
are_lgl_ish(c(TRUE, FALSE, NA))
#> [1] TRUE TRUE TRUE
is_lgl_ish(c(TRUE, FALSE, NA))
#> [1] TRUE

are_lgl_ish(c(1, 0, 1.0, NA))
#> [1] TRUE TRUE TRUE TRUE
is_lgl_ish(c(1, 0, 1.0, NA))
#> [1] TRUE

are_lgl_ish(c("T", "F", "TRUE", "FALSE", "true", "false", "1", "0"))
#> [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
is_lgl_ish(c("T", "F", "TRUE", "FALSE", "true", "false", "1", "0"))
#> [1] TRUE

are_lgl_ish(c("T", "F", "a", "1.1"))
#> [1]  TRUE  TRUE FALSE  TRUE
is_lgl_ish(c("T", "F", "a", "1.1"))
#> [1] FALSE

are_lgl_ish(factor(c("T", "a")))
#> [1]  TRUE FALSE
is_lgl_ish(factor(c("T", "a")))
#> [1] FALSE

are_lgl_ish(list(TRUE, 0, "F", "a"))
#> [1]  TRUE  TRUE  TRUE FALSE
is_lgl_ish(list(TRUE, 0, "F", "a"))
#> [1] FALSE
```
