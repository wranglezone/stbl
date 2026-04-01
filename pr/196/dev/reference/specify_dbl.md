# Create a specified double stabilizer function

`specify_dbl()` creates a function that will call
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md)
with the provided arguments. `specify_dbl_scalar()` creates a function
that will call
[`stabilize_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md)
with the provided arguments. `specify_double()` is a synonym of
`specify_dbl()`, and `specify_double_scalar()` is a synonym of
`specify_dbl_scalar()`.

## Usage

``` r
specify_dbl(
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  min_value = NULL,
  max_value = NULL
)

specify_dbl_scalar(
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL
)

specify_double(
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  min_value = NULL,
  max_value = NULL
)

specify_double_scalar(
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL
)
```

## Arguments

- allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

- allow_na:

  `(length-1 logical)` Are NA values ok?

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

- min_size:

  `(length-1 integer)` The minimum size of the object. Object size will
  be tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- max_size:

  `(length-1 integer)` The maximum size of the object. Object size will
  be tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- min_value:

  `(length-1 numeric)` The lowest allowed value for `x`. If `NULL`
  (default) values are not checked.

- max_value:

  `(length-1 numeric)` The highest allowed value for `x`. If `NULL`
  (default) values are not checked.

- allow_zero_length:

  `(length-1 logical)` Are zero-length vectors acceptable?

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md)
or
[`stabilize_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md)
with the provided arguments. The generated function will also accept
`...` for additional arguments to pass to
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md)
or
[`stabilize_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other double functions:
[`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md)

Other specification functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md)

## Examples

``` r
stabilize_3_to_5 <- specify_dbl(min_value = 3, max_value = 5)
stabilize_3_to_5(c(3.3, 4.4, 5))
#> [1] 3.3 4.4 5.0
try(stabilize_3_to_5(c(1:6)))
#> Error in eval(expr, envir) : `c(1:6)` must be >= 3.
#> ℹ Some values are too low.
#> ✖ Locations: 1 and 2
#> ✖ Values: 1 and 2
#> `c(1:6)` must be <= 5.
#> ℹ Some values are too high.
#> ✖ Location: 6
#> ✖ Value: 6
```
