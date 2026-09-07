# Create a specified any-of stabilizer function

`specify_any_of()` creates a function that will call
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md)
with the provided specs. `specify_any_of()`'s function tries each spec
in order and returns the result of the first one that succeeds.

## Usage

``` r
specify_any_of(...)
```

## Arguments

- ...:

  Unnamed stabilizer / `to_*` / `specify_*()` specs, forwarded to
  [`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md).

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md)
with the provided specs. The generated function will also accept `...`
for additional unnamed specs to pass to
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other specification functions:
[`specify_all_of()`](https://stbl.wrangle.zone/dev/reference/specify_all_of.md),
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_date()`](https://stbl.wrangle.zone/dev/reference/specify_date.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_df()`](https://stbl.wrangle.zone/dev/reference/specify_df.md),
[`specify_dttm()`](https://stbl.wrangle.zone/dev/reference/specify_dttm.md),
[`specify_dur()`](https://stbl.wrangle.zone/dev/reference/specify_dur.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md),
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md),
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_int_or_chr <- specify_any_of(specify_int(), specify_chr())
stabilize_int_or_chr(1L)
#> [1] 1
stabilize_int_or_chr("a")
#> [1] "a"
try(stabilize_int_or_chr(TRUE))
#> [1] 1
```
