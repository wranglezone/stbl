# Create a specified list stabilizer function

`specify_lst()` creates a function that will call
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md)
with the provided arguments. `specify_list()` is a synonym of
`specify_lst()`.

## Usage

``` r
specify_lst(
  ...,
  .named = NULL,
  .unnamed = NULL,
  .unique = FALSE,
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL
)

specify_list(
  ...,
  .named = NULL,
  .unnamed = NULL,
  .unique = FALSE,
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL
)
```

## Arguments

- ...:

  Named stabilizer functions, such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). Each name corresponds to a required element in `.x`, and the
  function is used to validate that element.

- .named:

  Controls how named elements of `.x` that are *not* explicitly listed
  in `...` are handled. One of:

  - `NULL` or `FALSE` (default): any extra named elements cause an
    error.

  - `TRUE`: extra named elements are allowed, unchecked.

  - A single stabilizer function, such as a `stabilize_*` function
    ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
    etc) or a function produced by a `specify_*()` function
    ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
    etc), used to validate every extra named element.

- .unnamed:

  Controls how unnamed elements of `.x` are handled. One of:

  - `NULL` or `FALSE` (default): any unnamed elements cause an error.

  - `TRUE`: unnamed elements are allowed, unchecked.

  - A single stabilizer function, such as a `stabilize_*` function
    ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
    etc) or a function produced by a `specify_*()` function
    ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
    etc), used to validate every unnamed element.

- .unique:

  (`logical(1)`) Should all elements in `.x` be distinct? If `TRUE`,
  duplicated elements are rejected.

- .allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- .min_size:

  (`integer(1)`) The minimum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- .max_size:

  (`integer(1)`) The maximum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md)
with the provided arguments. The generated function will also accept
`...` for additional named element specifications to pass to
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other list functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_lst()`](https://stbl.wrangle.zone/dev/reference/to_lst.md)

Other specification functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_date()`](https://stbl.wrangle.zone/dev/reference/specify_date.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_df()`](https://stbl.wrangle.zone/dev/reference/specify_df.md),
[`specify_dttm()`](https://stbl.wrangle.zone/dev/reference/specify_dttm.md),
[`specify_dur()`](https://stbl.wrangle.zone/dev/reference/specify_dur.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_config <- specify_lst(
  name = specify_chr_scalar(allow_na = FALSE),
  version = stabilize_int_scalar,
  debug = specify_lgl_scalar(allow_na = FALSE),
  .unnamed = stabilize_chr_scalar
)
stabilize_config(list(name = "myapp", version = 1L, debug = FALSE, "extra"))
#> $name
#> [1] "myapp"
#> 
#> $version
#> [1] 1
#> 
#> $debug
#> [1] FALSE
#> 
#> [[4]]
#> [1] "extra"
#> 
try(
  stabilize_config(
    list(name = "myapp", version = 1L, debug = FALSE, c("a", "b"))
  )
)
#> Error in eval(expr, envir) : 
#>   `list(name = "myapp", version = 1L, debug = FALSE, c("a", "b"))[[4]]`
#> must be a single <character>.
#> ✖ `list(name = "myapp", version = 1L, debug = FALSE, c("a", "b"))[[4]]` has 2
#>   values.
```
