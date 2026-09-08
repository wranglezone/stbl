# Create a specified each stabilizer function

`specify_each()` creates a function that will call
[`stabilize_each()`](https://stbl.wrangle.zone/dev/reference/stabilize_each.md)
with the provided `spec`, letting an element-wise spec be reused and
nested inside other `specify_*()`/`stabilize_*()` calls.

## Usage

``` r
specify_each(spec)
```

## Arguments

- spec:

  `(function)` A single stabilizer or coercion function, such as a
  `to_*` function
  ([`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
  etc.), a `stabilize_*` function
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc.), or a function produced by a `specify_*()` call
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc.). Applied independently to each element of `x`.

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_each()`](https://stbl.wrangle.zone/dev/reference/stabilize_each.md)
with the provided `spec`. The generated function will also accept
`simplify` and `...` to pass to
[`stabilize_each()`](https://stbl.wrangle.zone/dev/reference/stabilize_each.md).
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
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md),
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md),
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_ints <- specify_each(stabilize_int)
stabilize_ints(list("1", "2", "3"))
#> [1] 1 2 3
try(stabilize_ints(list("1", "a")))
#> Error in eval(expr, envir) : 
#>   `list("1", "a")` <list> must have every element satisfy `spec`.
#> ✖ Location 2: `list("1", "a")[[2]]` <character> must be coercible to <integer>
#>   (Locations: 1)
```
