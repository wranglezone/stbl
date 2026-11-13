# Create a specified time-of-day stabilizer function

`specify_time()` creates a function that will call
[`stabilize_time()`](https://stbl.wrangle.zone/dev/reference/stabilize_time.md)
with the provided arguments. `specify_time_scalar()` creates a function
that will call
[`stabilize_time_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_time_scalar.md)
with the provided arguments.

## Usage

``` r
specify_time(
  ...,
  treat_number_as = c("seconds", "milliseconds", "days", "error"),
  allow_null = TRUE,
  allow_na = TRUE,
  named = NULL,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
)

specify_time_scalar(
  ...,
  treat_number_as = c("seconds", "milliseconds", "days", "error"),
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  named = NULL,
  min_value = NULL,
  max_value = NULL,
  allowed_values = NULL
)
```

## Arguments

- ...:

  Arguments passed to methods.

- treat_number_as:

  (`character(1)`) How to interpret numeric input: `"seconds"` or
  `"milliseconds"` since midnight, `"days"` as a fraction of a day (so
  `0.5` is 12:00:00), or `"error"` to reject numbers. Ignored for
  non-numeric input.

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

- unique:

  (`logical(1)`) Should all elements in `x` be distinct?

- min_value:

  (`numeric(1)`) The lowest allowed value for `x`. If `NULL` (default)
  values are not checked.

- max_value:

  (`numeric(1)`) The highest allowed value for `x`. If `NULL` (default)
  values are not checked.

- allowed_values:

  A vector of permitted values (converted to the target type). `NULL`
  (default) skips the check. `NA` values in `x` are permitted
  independently of `allowed_values`, subject to `allow_na`.

- allow_zero_length:

  (`logical(1)`) Are zero-length vectors acceptable?

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_time()`](https://stbl.wrangle.zone/dev/reference/stabilize_time.md)
or
[`stabilize_time_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_time_scalar.md)
with the provided arguments. The generated function will also accept
`...` for additional arguments to pass to
[`stabilize_time()`](https://stbl.wrangle.zone/dev/reference/stabilize_time.md)
or
[`stabilize_time_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_time_scalar.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other time functions:
[`stabilize_time()`](https://stbl.wrangle.zone/dev/reference/stabilize_time.md),
[`stabilize_time_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_time_scalar.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_time()`](https://stbl.wrangle.zone/dev/reference/to_time.md),
[`to_time_scalar()`](https://stbl.wrangle.zone/dev/reference/to_time_scalar.md)

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
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md),
[`specify_lst_positional()`](https://stbl.wrangle.zone/dev/reference/specify_lst_positional.md),
[`specify_names()`](https://stbl.wrangle.zone/dev/reference/specify_names.md),
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md)

## Examples

``` r
stabilize_afternoon <- specify_time(min_value = "12:00:00Z")
stabilize_afternoon("13:00:00Z")
#> 13:00:00
try(stabilize_afternoon("06:00:00Z"))
#> Error in eval(expr, envir) : `"06:00:00Z"` must be >= 12:00:00.
#> ✖ "06:00:00" is too low.
```
