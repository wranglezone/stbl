# Create a specified logical stabilizer function

`specify_lgl()` creates a function that will call
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
with the provided arguments. `specify_lgl_scalar()` creates a function
that will call
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md)
with the provided arguments. `specify_logical()` is a synonym of
`specify_lgl()`, and `specify_logical_scalar()` is a synonym of
`specify_lgl_scalar()`.

## Usage

``` r
specify_lgl(
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  named = NULL,
  min_size = NULL,
  max_size = NULL,
  allowed_values = NULL
)

specify_lgl_scalar(
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  named = NULL,
  allowed_values = NULL
)

specify_logical(
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  named = NULL,
  min_size = NULL,
  max_size = NULL,
  allowed_values = NULL
)

specify_logical_scalar(
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  named = NULL,
  allowed_values = NULL
)
```

## Arguments

- ...:

  Arguments passed to methods.

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- allow_na:

  (`logical(1)`) Are NA values ok?

- named:

  Controls the names of `x`. `NULL` (default), `NA`, or `character(0)`
  skip the check. `TRUE` requires every element to have a non-empty
  name; `FALSE` requires that no elements are named. A character vector
  (or factor) requires `x` to be named, with every name in the vector. A
  single stabilizer or conversion function (such as
  [`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  a `to_*` function, or the result of
  [`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md))
  requires `x` to be named and is applied to `names(x)`, so every name
  must satisfy it.

- min_size:

  (`integer(1)`) The minimum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- max_size:

  (`integer(1)`) The maximum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- allowed_values:

  A vector of permitted values (converted to the target type). `NULL`
  (default) skips the check. `NA` values in `x` are permitted
  independently of `allowed_values`, subject to `allow_na`.

- allow_zero_length:

  (`logical(1)`) Are zero-length vectors acceptable?

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
or
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md)
with the provided arguments. The generated function will also accept
`...` for additional arguments to pass to
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
or
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other logical functions:
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md),
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md)

Other specification functions:
[`specify_all_of()`](https://stbl.wrangle.zone/dev/reference/specify_all_of.md),
[`specify_any_of()`](https://stbl.wrangle.zone/dev/reference/specify_any_of.md),
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_date()`](https://stbl.wrangle.zone/dev/reference/specify_date.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_df()`](https://stbl.wrangle.zone/dev/reference/specify_df.md),
[`specify_dttm()`](https://stbl.wrangle.zone/dev/reference/specify_dttm.md),
[`specify_dur()`](https://stbl.wrangle.zone/dev/reference/specify_dur.md),
[`specify_each()`](https://stbl.wrangle.zone/dev/reference/specify_each.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md),
[`specify_lst_positional()`](https://stbl.wrangle.zone/dev/reference/specify_lst_positional.md),
[`specify_names()`](https://stbl.wrangle.zone/dev/reference/specify_names.md),
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md),
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_few_lgl <- specify_lgl(max_size = 5)
stabilize_few_lgl(c(TRUE, "False", TRUE))
#> [1]  TRUE FALSE  TRUE
try(stabilize_few_lgl(rep(TRUE, 10)))
#> Error in eval(expr, envir) : `rep(TRUE, 10)` must have size <= 5.
#> ✖ 10 is too big.
```
