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
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL
)

specify_list(
  ...,
  .named = NULL,
  .unnamed = NULL,
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL
)
```

## Arguments

- ...:

  Named
  [`specify_*()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md)
  functions for required named elements of `.x`. Each name corresponds
  to a required element in `.x`, and the function is used to validate
  that element.

- .named:

  A single
  [`specify_*()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md)
  function to validate all named elements of `.x` that are *not*
  explicitly listed in `...`. If `NULL` (default), any extra named
  elements will cause an error.

- .unnamed:

  A single
  [`specify_*()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md)
  function to validate all unnamed elements of `.x`. If `NULL`
  (default), any unnamed elements will cause an error.

- .allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

- .min_size:

  `(length-1 integer)` The minimum size of the object. Object size will
  be tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- .max_size:

  `(length-1 integer)` The maximum size of the object. Object size will
  be tested using
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
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`to_lst()`](https://stbl.wrangle.zone/dev/reference/to_lst.md)

Other specification functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_present()`](https://stbl.wrangle.zone/dev/reference/specify_present.md)

## Examples

``` r
stabilize_config <- specify_lst(
  name = specify_chr_scalar(),
  .min_size = 1
)
stabilize_config(list(name = "myapp"))
#> $name
#> [1] "myapp"
#> 
try(stabilize_config(list()))
#> Error in eval(expr, envir) : `list()` must have size >= 1.
#> ✖ 0 is too small.
```
