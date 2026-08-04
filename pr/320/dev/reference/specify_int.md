# Create a specified integer stabilizer function

`specify_int()` creates a function that will call
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md)
with the provided arguments. `specify_int_scalar()` creates a function
that will call
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md)
with the provided arguments. `specify_integer()` is a synonym of
`specify_int()`, and `specify_integer_scalar()` is a synonym of
`specify_int_scalar()`.

## Usage

``` r
specify_int(
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL
)

specify_int_scalar(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL
)

specify_integer(
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL
)

specify_integer_scalar(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL
)
```

## Arguments

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- allow_na:

  (`logical(1)`) Are NA values ok?

- coerce_character:

  (`logical(1)`) Should character vectors such as "1" and "2.0" be
  considered numeric-ish?

- coerce_factor:

  (`logical(1)`) Should factors with values such as "1" and "2.0" be
  considered numeric-ish? Note that this package uses the character
  value from the factor, while
  [`as.integer()`](https://rdrr.io/r/base/integer.html) and
  [`as.double()`](https://rdrr.io/r/base/double.html) use the integer
  index of the factor.

- min_size:

  (`integer(1)`) The minimum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- max_size:

  (`integer(1)`) The maximum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- unique:

  (`logical(1)`) Should all elements in `x` be distinct?

- min_value:

  (`numeric(1)`) The lowest allowed value for `x`. If `NULL` (default)
  values are not checked.

- max_value:

  (`numeric(1)`) The highest allowed value for `x`. If `NULL` (default)
  values are not checked.

- allow_zero_length:

  (`logical(1)`) Are zero-length vectors acceptable?

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md)
or
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md)
with the provided arguments. The generated function will also accept
`...` for additional arguments to pass to
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md)
or
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other integer functions:
[`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_int()`](https://stbl.wrangle.zone/dev/reference/to_int.md),
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/to_int_scalar.md)

Other specification functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_df()`](https://stbl.wrangle.zone/dev/reference/specify_df.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md)

## Examples

``` r
stabilize_3_to_5 <- specify_int(min_value = 3, max_value = 5)
stabilize_3_to_5(c(3:5))
#> [1] 3 4 5
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
