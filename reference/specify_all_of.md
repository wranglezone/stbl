# Create a specified all-of stabilizer function

`specify_all_of()` creates a function that will call
[`stabilize_all_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_all_of.md)
with the provided specs. `specify_all_of()`'s function requires that `x`
satisfy every provided spec, and that all specs agree on the coerced
result.

## Usage

``` r
specify_all_of(...)
```

## Arguments

- ...:

  Unnamed stabilizer functions, forwarded to
  [`stabilize_all_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_all_of.md).

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_all_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_all_of.md)
with the provided specs. The generated function will also accept `...`
for additional unnamed specs to pass to
[`stabilize_all_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_all_of.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other specification functions:
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
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md),
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_a_then_b <- specify_all_of(
  specify_chr(regex = "^a"),
  specify_chr(regex = "b$")
)
stabilize_a_then_b("ab")
#> [1] "ab"
try(stabilize_a_then_b("ba"))
#> Error in eval(expr, envir) : 
#>   `"ba"` must match all of the provided stabilizers.
#> ✖ `"ba"` must match the regex pattern "^a"
```
