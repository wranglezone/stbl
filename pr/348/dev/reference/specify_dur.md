# Create a specified duration stabilizer function

`specify_dur()` creates a function that will call
[`stabilize_dur()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur.md)
with the provided arguments. `specify_dur_scalar()` creates a function
that will call
[`stabilize_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur_scalar.md)
with the provided arguments. `specify_duration()` is a synonym of
`specify_dur()`, and `specify_duration_scalar()` is a synonym of
`specify_dur_scalar()`.

## Usage

``` r
specify_dur(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
)

specify_dur_scalar(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
)

specify_duration(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
)

specify_duration_scalar(
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
)
```

## Arguments

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

- unique:

  (`logical(1)`) Should all elements in `x` be distinct?

- min_value:

  (`numeric(1)`) The lowest allowed value for `x`. If `NULL` (default)
  values are not checked.

- max_value:

  (`numeric(1)`) The highest allowed value for `x`. If `NULL` (default)
  values are not checked.

- allowed_values:

  A vector of permitted values (coerced to the target type). `NULL`
  (default) skips the check. `NA` values in `x` are permitted
  independently of `allowed_values`, subject to `allow_na`.

- allow_zero_length:

  (`logical(1)`) Are zero-length vectors acceptable?

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_dur()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur.md)
or
[`stabilize_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur_scalar.md)
with the provided arguments. The generated function will also accept
`...` for additional arguments to pass to
[`stabilize_dur()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur.md)
or
[`stabilize_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur_scalar.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other duration functions:
[`stabilize_dur()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur.md),
[`stabilize_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur_scalar.md),
[`to_dur()`](https://stbl.wrangle.zone/dev/reference/to_dur.md),
[`to_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dur_scalar.md)

Other specification functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_date()`](https://stbl.wrangle.zone/dev/reference/specify_date.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_df()`](https://stbl.wrangle.zone/dev/reference/specify_df.md),
[`specify_dttm()`](https://stbl.wrangle.zone/dev/reference/specify_dttm.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md),
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_short <- specify_dur(max_value = "P1D")
stabilize_short("PT12H")
#> [1] "12H 0M 0S"
try(stabilize_short("P2D"))
#> Error in eval(expr, envir) : `"P2D"` must be <= 1d 0H 0M 0S.
#> ✖ "2d 0H 0M 0S" is too high.
```
