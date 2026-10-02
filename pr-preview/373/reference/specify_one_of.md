# Create a specified one-of stabilizer function

`specify_one_of()` creates a function that will call
[`stabilize_one_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_one_of.md)
with the provided specs. `specify_one_of()`'s function requires that
exactly one of the provided specs succeeds.

## Usage

``` r
specify_one_of(...)
```

## Arguments

- ...:

  Unnamed stabilizer / `to_*` / `specify_*()` specs, forwarded to
  [`stabilize_one_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_one_of.md).

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_one_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_one_of.md)
with the provided specs. The generated function will also accept `...`
for additional unnamed specs to pass to
[`stabilize_one_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_one_of.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

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
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_int_xor_chr <- specify_one_of(stabilize_int, stabilize_chr)
stabilize_int_xor_chr("a")
#> [1] "a"
try(stabilize_int_xor_chr("1"))
#> Error in eval(expr, envir) : 
#>   `"1"` must match exactly one of the provided specifications, but matched
#> 2.
#> ℹ Matched specifications: "<fn>" (1) and "<fn>" (2)
```
