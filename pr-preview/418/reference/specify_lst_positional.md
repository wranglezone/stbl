# Create a specified positional list stabilizer function

`specify_lst_positional()` creates a function that will call
[`stabilize_lst_positional()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst_positional.md)
with the provided arguments. `specify_list_positional()` and
`specify_tuple()` are synonyms.

## Usage

``` r
specify_lst_positional(
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE
)

specify_list_positional(
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE
)

specify_tuple(
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE
)
```

## Arguments

- ...:

  Unnamed stabilizer functions, such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc), `to_*` functions, or functions produced by `specify_*()`
  functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). The *i*th function validates the *i*th element of `.x`. At least
  one function is required.

- .additional:

  Controls how elements of `.x` after the last spec in `...` are
  handled. One of:

  - `NULL` or `FALSE` (default): any extra elements cause an error.

  - `TRUE`: extra elements are allowed, unchecked.

  - A single stabilizer function, used to validate every extra element.

- .n_required:

  `(integer(1))` The number of leading positions that must be present in
  `.x`. Defaults to all of them. Must be between 0 and the number of
  specs. A zero-length `.x` (such as
  [`list()`](https://rdrr.io/r/base/list.html)) skips this check when
  `.allow_zero_length = TRUE`. This is independent of `.min_size` and
  `.max_size`, which check the total length.

- .unique:

  (`logical(1)`) Should all elements in `x` be distinct?

- .allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- .allow_zero_length:

  (`logical(1)`) Are zero-length vectors acceptable?

- .min_size:

  (`integer(1)`) The minimum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- .max_size:

  (`integer(1)`) The maximum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- .simplify:

  (`logical(1)`) Should per-element results be combined into a single
  atomic vector when possible (every result has size 1 and shares a
  common type)? If `FALSE`, a list is always returned.

- .coerce_function:

  (`logical(1)`) Should functions be converted?

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_lst_positional()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst_positional.md)
with the provided arguments. The generated function will also accept
`...` for additional positional specifications, which are appended after
those given to `specify_lst_positional()`. You can copy/paste the body
of the resulting function if you want to provide additional context or
functionality.

## See also

Other list functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`stabilize_lst_positional()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst_positional.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_lst()`](https://stbl.wrangle.zone/dev/reference/to_lst.md)

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
[`specify_names()`](https://stbl.wrangle.zone/dev/reference/specify_names.md),
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md),
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_point <- specify_tuple(
  stabilize_dbl_scalar,
  stabilize_dbl_scalar
)
stabilize_point(list(-122.4, 37.8))
#> [[1]]
#> [1] -122.4
#> 
#> [[2]]
#> [1] 37.8
#> 
try(stabilize_point(list(-122.4, "north")))
#> Error in eval(expr, envir) : 
#>   `list(-122.4, "north")` <list> must satisfy the spec at every position.
#> ✖ Position 2: `list(-122.4, "north")[[2]]` <character> must be convertible to
#>   <double> (Locations: 1)
```
