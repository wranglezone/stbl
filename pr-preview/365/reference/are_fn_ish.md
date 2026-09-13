# Check if an object can be safely coerced to a function

`are_fn_ish()` is a vectorized predicate function that checks whether
each element of its input can be safely coerced to a function.
`are_function_ish()` is a synonym of `are_fn_ish()`.

`is_fn_ish()` is a scalar predicate that checks whether its input can be
safely coerced to a function by
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md).
`is_function_ish()` is a synonym of `is_fn_ish()`.

## Usage

``` r
are_fn_ish(x, ...)

are_function_ish(x, ...)

is_fn_ish(x, ...)

is_function_ish(x, ...)
```

## Arguments

- x:

  The object to check.

- ...:

  Arguments passed to methods.

## Value

`are_fn_ish()` returns a logical vector with the same length as the
input. `is_fn_ish()` returns a `length-1 logical` (`TRUE` or `FALSE`).

## Details

`are_fn_ish()` returns `TRUE` for:

- Functions (including lambda functions created with `~` or `\()`)

- Formulas (one-sided or two-sided, coercible via
  [`rlang::as_function()`](https://rlang.r-lib.org/reference/as_function.html))

- Character strings that are syntactically valid function names: either
  a bare name (`"mean"`) or a namespaced name (`"pkg::fn"`). The check
  is syntactic; it does not verify that the named function exists in any
  environment.

`is_fn_ish()` returns `TRUE` for objects that
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md) can coerce
without error (assuming a matching function exists in the search path):

- Functions (including lambda functions created with `~` or `\()`)

- One-sided or two-sided formulas

- Single non-`NA` character strings (including namespaced `"pkg::fn"`
  names)

`NULL` and length-0 character vectors are *not* considered function-ish
because they do not represent a callable object;
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md) converts
them to `NULL` only as a permissive special case controlled by
`allow_null`.

## See also

Other function functions:
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md)

Other check functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
[`are_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
[`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md)

## Examples

``` r
are_fn_ish(mean)
#> [1] TRUE
are_fn_ish(~ . + 1)
#> [1] TRUE
are_fn_ish(c("mean", "stats::median", NA, "", "1bad"))
#> [1]  TRUE  TRUE FALSE FALSE FALSE
are_fn_ish(NULL)
#> logical(0)
are_fn_ish(1L)
#> [1] FALSE

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
