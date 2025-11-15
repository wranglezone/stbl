# Create a specified logical stabilizer function

`specify_lgl()` creates a function that will call
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
with the provided arguments. `specify_lgl_scalar()` creates a function
that will call
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
with the provided arguments. `specify_logical()` is a synonym of
`specify_lgl()`, and `specify_logical_scalar()` is a synonym of
`specify_lgl_scalar()`.

## Usage

``` r
specify_lgl(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL
)

specify_lgl_scalar(
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE
)

specify_logical(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL
)

specify_logical_scalar(
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE
)
```

## Arguments

- allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

- allow_na:

  `(length-1 logical)` Are NA values ok?

- min_size:

  `(length-1 integer)` The minimum size of the object. Object size will
  be tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- max_size:

  `(length-1 integer)` The maximum size of the object. Object size will
  be tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- allow_zero_length:

  `(length-1 logical)` Are zero-length vectors acceptable?

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
or
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
with the provided arguments. The generated function will also accept
`...` for additional arguments to pass to
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
or
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other logical functions:
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)

Other specification functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md)

## Examples

``` r
stabilize_few_lgl <- specify_lgl(max_size = 5)
stabilize_few_lgl(c(TRUE, "False", TRUE))
#> [1]  TRUE FALSE  TRUE
try(stabilize_few_lgl(rep(TRUE, 10)))
#> Error in eval(expr, envir) : `rep(TRUE, 10)` must have size <= 5.
#> ✖ 10 is too big.
```
