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
  .col_names = lifecycle::deprecated(),
  .min_rows = NULL,
  .max_rows = NULL,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .required = ...names()
)

specify_data_frame(
  ...,
  .extra_cols = NULL,
  .col_names = lifecycle::deprecated(),
  .min_rows = NULL,
  .max_rows = NULL,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .required = ...names()
)
```

## Arguments

- ...:

  Named stabilizer functions, such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). Each name corresponds to a column in `.x`, and the function is
  used to validate that column when present. Whether the column is
  required is controlled by `.required`.

- .extra_cols:

  Controls how columns of `.x` that are *not* explicitly listed in `...`
  are handled. One of:

  - `NULL` (default): any extra columns cause an error. Names in
    `.required` that have no spec in `...` are allowed, unchecked.

  - `FALSE`: any extra columns cause an error, and every name in
    `.required` must have a spec in `...`.

  - `TRUE`: extra columns are allowed, unchecked.

  - A single stabilizer function, such as a `stabilize_*` function
    ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
    etc) or a function produced by a `specify_*()` function
    ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
    etc), used to validate every extra column.

- .col_names:

  **\[deprecated\]** Use `.required` instead.

- .min_rows:

  (`integer(1)`) The minimum number of rows allowed in `.x`. If `NULL`
  (default), the row count is not checked.

- .max_rows:

  (`integer(1)`) The maximum number of rows allowed in `.x`. If `NULL`
  (default), the row count is not checked.

- .allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- .allow_zero_length:

  (`logical(1)`) Are zero-length vectors acceptable?

- .required:

  `(character or list)` Names of columns that must be present in `.x`.
  Defaults to all names in `...`, so every named spec is required unless
  you opt it out. A supplied `.required` *replaces* that default, so
  `.required = list(card = "address")` makes every other spec optional;
  list the unconditional names explicitly. Specs for names that are not
  required are optional: if absent, no error is raised; if present,
  they're validated normally. Pass `NULL` or
  [`character()`](https://rdrr.io/r/base/character.html) to make every
  named spec optional. Every name in `.required` is enforced, whether or
  not it has a spec in `...` (see `.extra_cols`). A `.x` with zero
  columns skips this check when `.allow_zero_length = TRUE` (the
  default). See `required` in \[stabilize_names)()\] for details on
  expressing conditional requirements.

  \[stabilize_names)()\]: R:stabilize_names)()

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
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_df()`](https://stbl.wrangle.zone/dev/reference/to_df.md)

Other specification functions:
[`specify_all_of()`](https://stbl.wrangle.zone/dev/reference/specify_all_of.md),
[`specify_any_of()`](https://stbl.wrangle.zone/dev/reference/specify_any_of.md),
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_date()`](https://stbl.wrangle.zone/dev/reference/specify_date.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_dttm()`](https://stbl.wrangle.zone/dev/reference/specify_dttm.md),
[`specify_dur()`](https://stbl.wrangle.zone/dev/reference/specify_dur.md),
[`specify_each()`](https://stbl.wrangle.zone/dev/reference/specify_each.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md),
[`specify_lst_positional()`](https://stbl.wrangle.zone/dev/reference/specify_lst_positional.md),
[`specify_names()`](https://stbl.wrangle.zone/dev/reference/specify_names.md),
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md),
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_person_df <- specify_df(
  name = specify_chr_scalar(allow_na = FALSE),
  age = specify_int_scalar(allow_na = FALSE),
  .extra_cols = assert_present
)
stabilize_person_df(data.frame(name = "Alice", age = 30L, score = 99.5))
#>    name age score
#> 1 Alice  30  99.5
try(stabilize_person_df(data.frame(name = "Alice")))
#> Error in eval(expr, envir) : 
#>   `data.frame(name = "Alice")` must contain column "age".

# Mark a column as optional via .required
stabilize_person_df2 <- specify_df(
  name = specify_chr_scalar(allow_na = FALSE),
  age = specify_int_scalar(allow_na = FALSE),
  .required = "name"
)
stabilize_person_df2(data.frame(name = "Alice"))
#>    name
#> 1 Alice

# Require a column only when another is present
stabilize_person_df3 <- specify_df(
  name = specify_chr_scalar(allow_na = FALSE),
  card = specify_int_scalar(),
  address = specify_chr_scalar(),
  .required = list("name", card = "address")
)
try(stabilize_person_df3(data.frame(name = "Alice", card = 1L)))
#> Error in eval(expr, envir) : 
#>   `data.frame(name = "Alice", card = 1L)` must contain column "address"
#> when "card" is present.
```
