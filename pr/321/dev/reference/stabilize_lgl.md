# Coerce to logical with additional checks

Compared to
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
`stabilize_lgl()` checks more details, but is slower. `stabilise_lgl()`,
`stabilize_logical()`, and `stabilise_logical()` are synonyms of
`stabilize_lgl()`.

## Usage

``` r
stabilize_lgl(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_logical(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_lgl(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_logical(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  allowed_values = NULL,
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

  (`logical(1)`) Is NULL an acceptable value?

- allow_na:

  (`logical(1)`) Are NA values ok?

- min_size:

  (`integer(1)`) The minimum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- max_size:

  (`integer(1)`) The maximum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- allowed_values:

  A vector of permitted values (coerced to the target type). `NULL`
  (default) skips the check. `NA` values in `x` are permitted
  independently of `allowed_values`, subject to `allow_na`.

- x_arg:

  (`character(1)`) The name of the argument being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  (`character(1)`) The class name of the argument being stabilized to
  use in error messages. Use this if you remove a special class from the
  object before checking its coercion, but want the error message to
  match the original class.

## Value

The input as a logical vector, or an error condition with classes
`<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
`<condition>`, and a specific class by failure mode:

- `<stbl-error-coerce-logical>` when `x` cannot be coerced to logical.

- `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.

- `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.

- `<stbl-error-size_too_small>` when the vector is shorter than
  `min_size`.

- `<stbl-error-size_too_large>` when the vector is longer than
  `max_size`.

- `<stbl-error-allowed_values>` when values are not in `allowed_values`.

## See also

Other logical functions:
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md)

Other stabilization functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md),
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr_scalar.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl_scalar.md),
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct_scalar.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md),
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
stabilize_lgl(c(TRUE, FALSE, TRUE))
#> [1]  TRUE FALSE  TRUE
stabilize_lgl("true")
#> [1] TRUE
stabilize_lgl(NULL)
#> NULL
try(stabilize_lgl(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
try(stabilize_lgl(c(TRUE, NA), allow_na = FALSE))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, NA)` must not contain NA values.
#> • NA locations: 2
try(stabilize_lgl(letters))
#> Error in eval(expr, envir) : 
#>   `letters` <character> must be coercible to <logical>
#> ✖ Can't convert some values due to incompatible values.
#> • Locations: 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, …,
#>   25, and 26
try(stabilize_lgl(c(TRUE, FALSE, TRUE), min_size = 5))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, FALSE, TRUE)` must have size >= 5.
#> ✖ 3 is too small.
try(stabilize_lgl(c(TRUE, FALSE, TRUE), max_size = 2))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, FALSE, TRUE)` must have size <= 2.
#> ✖ 3 is too big.
try(stabilize_lgl(c(TRUE, FALSE), allowed_values = TRUE))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, FALSE)` must be one of the allowed values.
#> ℹ Allowed value: "TRUE".
#> ✖ Unexpected location: 2
#> ✖ Unexpected value: "FALSE".
```
