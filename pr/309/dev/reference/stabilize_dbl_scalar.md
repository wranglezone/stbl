# Coerce to length-1 double with additional checks

Checks whether a vector can be coerced to a length-1 double vector.
`stabilize_dbl_scalar()` is optimized to check for length-1 double
vectors (compared to
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md)
with `max_size = 1`). `stabilise_dbl_scalar`,
`stabilize_double_scalar()`, and `stabilise_double_scalar` are synonyms
of `stabilize_dbl_scalar()`.

## Usage

``` r
stabilize_dbl_scalar(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_double_scalar(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_dbl_scalar(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_double_scalar(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The argument to stabilize.

- ...:

  Arguments passed to methods.

- allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

- allow_zero_length:

  `(length-1 logical)` Are zero-length vectors acceptable?

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

- min_value:

  `(length-1 numeric)` The lowest allowed value for `x`. If `NULL`
  (default) values are not checked.

- max_value:

  `(length-1 numeric)` The highest allowed value for `x`. If `NULL`
  (default) values are not checked.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  `(length-1 character)` The class name of the argument being stabilized
  to use in error messages. Use this if you remove a special class from
  the object before checking its coercion, but want the error message to
  match the original class.

## Value

The input as a length-1 double vector.

## See also

Other double functions:
[`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_dbl()`](https://stbl.wrangle.zone/dev/reference/to_dbl.md),
[`to_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dbl_scalar.md)

Other stabilization functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md),
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr_scalar.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct_scalar.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md),
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
[`to_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/to_chr_scalar.md),
[`to_dbl()`](https://stbl.wrangle.zone/dev/reference/to_dbl.md),
[`to_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dbl_scalar.md),
[`to_fct()`](https://stbl.wrangle.zone/dev/reference/to_fct.md),
[`to_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/to_fct_scalar.md),
[`to_int()`](https://stbl.wrangle.zone/dev/reference/to_int.md),
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/to_int_scalar.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md)

## Examples

``` r
stabilize_dbl_scalar(1.0)
#> [1] 1
stabilize_dbl_scalar("1.1")
#> [1] 1.1
try(stabilize_dbl_scalar(1:10))
#> Error in eval(expr, envir) : 
#>   `1:10` must be a single <numeric>.
#> ✖ `1:10` has 10 values.
try(stabilize_dbl_scalar(NULL))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
stabilize_dbl_scalar(NULL, allow_null = TRUE)
#> NULL
```
