# Check if an object can be safely coerced to a function

`is_fn_ish()` is a predicate function that checks whether its input can
be safely coerced to a function by
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md).
`is_function_ish()` is a synonym of `is_fn_ish()`.

## Usage

``` r
is_fn_ish(x, ...)

is_function_ish(x, ...)
```

## Arguments

- x:

  The object to check.

- ...:

  Arguments passed to methods.

## Value

A `length-1 logical` (`TRUE` or `FALSE`).

## Details

`is_fn_ish()` returns `TRUE` for objects that
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md) can coerce
without error (assuming a matching function exists in the search path):

- Functions (including lambda functions created with `~` or `\()`)

- Single non-`NA` character strings (including namespaced `"pkg::fn"`
  names)

- One-sided or two-sided formulas (coerced via
  [`rlang::as_function()`](https://rlang.r-lib.org/reference/as_function.html))

`NULL` and length-0 character vectors are *not* considered function-ish
because they do not represent a callable object;
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md) converts
them to `NULL` only as a permissive special case controlled by
`allow_null`.

## See also

Other function functions:
[`specify_fn()`](https://stbl.wrangle.zone/dev/reference/specify_fn.md),
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md)

Other check functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
[`are_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
[`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md)

## Examples

``` r
is_fn_ish(mean)
#> [1] TRUE
is_fn_ish("mean")
#> [1] TRUE
is_fn_ish("stats::median")
#> [1] TRUE
is_fn_ish(~ . + 1)
#> [1] TRUE
is_fn_ish(NULL)
#> [1] FALSE
is_fn_ish(1L)
#> [1] FALSE
```
