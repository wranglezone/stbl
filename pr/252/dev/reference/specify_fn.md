# Create a specified function coercer

`specify_fn()` creates a function that will call
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md) with the
provided arguments pre-filled. `specify_function()` is a synonym of
`specify_fn()`.

## Usage

``` r
specify_fn(allow_null = TRUE, definition_env = rlang::global_env())

specify_function(allow_null = TRUE, definition_env = rlang::global_env())
```

## Arguments

- allow_null:

  `(length-1 logical)` Is `NULL` an acceptable return value? See
  [`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md) for
  details.

- definition_env:

  `(environment)` The environment in which to look up function names.
  See [`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md) for
  details.

## Value

A function of class `"stbl_specified_fn"` that calls
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md) with the
provided arguments. The generated function also accepts `...` for
additional arguments to pass to
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md). You can
copy/paste the body of the resulting function if you want to provide
additional context or functionality.

## See also

Other function functions:
[`are_fn_ish()`](https://stbl.wrangle.zone/dev/reference/are_fn_ish.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md)

Other specification functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_df()`](https://stbl.wrangle.zone/dev/reference/specify_df.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md)

## Examples

``` r
to_pkg_fn <- specify_fn(definition_env = asNamespace("stats"))
to_pkg_fn("median")
#> function (x, na.rm = FALSE, ...) 
#> UseMethod("median")
#> <bytecode: 0x5582828079d8>
#> <environment: namespace:stats>
try(to_pkg_fn(NULL))
#> NULL
```
