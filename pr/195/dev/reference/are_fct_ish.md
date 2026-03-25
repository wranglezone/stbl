# Check if an object can be safely coerced to a factor

`are_fct_ish()` is a vectorized predicate function that checks whether
each element of its input can be safely coerced to a factor.
`are_factor_ish()` is a synonym of `are_fct_ish()`.

`is_fct_ish()` is a scalar predicate function that checks if all
elements of its input can be safely coerced to a factor.
`is_factor_ish()` is a synonym of `is_fct_ish()`.

## Usage

``` r
are_fct_ish(x, ..., levels = NULL, to_na = character())

is_fct_ish(x, ...)

are_factor_ish(x, ..., levels = NULL, to_na = character())

is_factor_ish(x, ...)

# Default S3 method
are_fct_ish(x, ..., levels = NULL, to_na = character(), depth = 1)
```

## Arguments

- x:

  The object to check.

- ...:

  Arguments passed to methods.

- levels:

  `(character)` The desired factor levels.

- to_na:

  `(character)` Values to convert to `NA`.

- depth:

  `(length-1 integer)` Current recursion depth. Do not manually set this
  parameter.

## Value

`are_fct_ish()` returns a logical vector with the same length as the
input. `is_fct_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`)
for the entire vector.

## See also

Other factor functions:
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md)

Other check functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
[`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md)

## Examples

``` r
# When `levels` is `NULL`, atomic vectors are fct_ish, but nested lists are not.
are_fct_ish(c("a", 1, NA))
#> [1] TRUE TRUE TRUE
is_fct_ish(c("a", 1, NA))
#> [1] TRUE
are_fct_ish(list("a", list("b", "c")))
#> [1]  TRUE FALSE
is_fct_ish(list("a", list("b", "c")))
#> [1] FALSE

# When `levels` is specified, values must be in `levels` or `to_na`.
are_fct_ish(c("a", "b", "c"), levels = c("a", "b"))
#> [1]  TRUE  TRUE FALSE
is_fct_ish(c("a", "b", "c"), levels = c("a", "b"))
#> [1] FALSE

# The `to_na` argument allows some values to be treated as `NA`.
are_fct_ish(c("a", "b", "z"), levels = c("a", "b"), to_na = "z")
#> [1] TRUE TRUE TRUE
is_fct_ish(c("a", "b", "z"), levels = c("a", "b"), to_na = "z")
#> [1] TRUE

# Factors are also checked against the specified levels.
are_fct_ish(factor(c("a", "b", "c")), levels = c("a", "b"))
#> [1]  TRUE  TRUE FALSE
is_fct_ish(factor(c("a", "b", "c")), levels = c("a", "b"))
#> [1] FALSE
```
