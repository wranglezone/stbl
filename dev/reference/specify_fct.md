# Create a specified factor stabilizer function

`specify_fct()` creates a function that will call
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md)
with the provided arguments. `specify_fct_scalar()` creates a function
that will call
[`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md)
with the provided arguments. `specify_factor()` is a synonym of
`specify_fct()`, and `specify_factor_scalar()` is a synonym of
`specify_fct_scalar()`.

## Usage

``` r
specify_fct(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  levels = NULL,
  to_na = character()
)

specify_fct_scalar(
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  levels = NULL,
  to_na = character()
)

specify_factor(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  levels = NULL,
  to_na = character()
)

specify_factor_scalar(
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  levels = NULL,
  to_na = character()
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

- levels:

  `(character)` Expected levels. If `NULL` (default), the levels will be
  computed by [`base::factor()`](https://rdrr.io/r/base/factor.html).

- to_na:

  `(character)` Values to convert to `NA`.

- allow_zero_length:

  `(length-1 logical)` Are zero-length vectors acceptable?

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md)
or
[`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md)
with the provided arguments. The generated function will also accept
`...` for additional arguments to pass to
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md)
or
[`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other factor functions:
[`are_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md)

Other specification functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md)

## Examples

``` r
stabilize_lowercase_letter <- specify_fct(levels = letters)
stabilize_lowercase_letter(c("s", "t", "b", "l"))
#> [1] s t b l
#> Levels: a b c d e f g h i j k l m n o p q r s t u v w x y z
try(stabilize_lowercase_letter("A"))
#> Error in eval(expr, envir) : 
#>   All values of `"A"` must be present in `levels` or `to_na`.
#> ℹ Disallowed values: A
#> ℹ Allowed values: a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, …, y,
#>   and z
```
