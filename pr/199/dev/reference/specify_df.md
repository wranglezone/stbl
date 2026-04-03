# Create a specified data frame stabilizer function

`specify_df()` creates a function that will call
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md)
with the provided arguments. `specify_data_frame()` is a synonym of
`specify_df()`.

## Usage

``` r
specify_df(
  ...,
  .extra_cols = NULL,
  .col_names = NULL,
  .min_rows = NULL,
  .max_rows = NULL,
  .allow_null = TRUE
)

specify_data_frame(
  ...,
  .extra_cols = NULL,
  .col_names = NULL,
  .min_rows = NULL,
  .max_rows = NULL,
  .allow_null = TRUE
)
```

## Arguments

- ...:

  Named stabilizer functions, such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). Each name corresponds to a required column in `.x`, and the
  function is used to validate that column.

- .extra_cols:

  A single stabilizer function, such as a `stabilize_*` function
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or a function produced by a `specify_*()` function
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). This function is used to validate all columns of `.x` that are
  *not* explicitly listed in `...`. If `NULL` (default), any extra
  columns will cause an error.

- .col_names:

  `(character)` A character vector of column names that must be present
  in `.x`. Any columns listed here that are absent from `.x` will cause
  an error. Unlike `...`, this does not validate the column contents.

- .min_rows:

  `(length-1 integer)` The minimum number of rows allowed in `.x`. If
  `NULL` (default), the row count is not checked.

- .max_rows:

  `(length-1 integer)` The maximum number of rows allowed in `.x`. If
  `NULL` (default), the row count is not checked.

- .allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md)
with the provided arguments. The generated function will also accept
`...` for additional named column specifications to pass to
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other data frame functions:
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md),
[`to_df()`](https://stbl.wrangle.zone/dev/reference/to_df.md)

Other specification functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md)

## Examples

``` r
stabilize_person_df <- specify_df(
  name = specify_chr_scalar(allow_na = FALSE),
  age = specify_int_scalar(allow_na = FALSE),
  .extra_cols = stabilize_present
)
stabilize_person_df(data.frame(name = "Alice", age = 30L, score = 99.5))
#>    name age score
#> 1 Alice  30  99.5
try(stabilize_person_df(data.frame(name = "Alice")))
#> Error in eval(expr, envir) : 
#>   `data.frame(name = "Alice")` must contain element "age".
```
