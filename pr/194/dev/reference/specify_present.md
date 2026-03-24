# Create a specified "present" validator function

`specify_present()` creates a function that validates that an element is
present (i.e., not `NULL`). Any non-`NULL` value passes. This is useful
when you need to require a named list element without imposing any type
constraints on its value.

## Usage

``` r
specify_present()
```

## Value

A function of class `"stbl_specified_fn"` that errors if the value is
`NULL` and returns it unchanged otherwise.

## See also

Other specification functions:
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md)

## Examples

``` r
check_present <- specify_present()
check_present("any value")
#> [1] "any value"
check_present(list(1, 2, 3))
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 2
#> 
#> [[3]]
#> [1] 3
#> 
try(check_present(NULL))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
```
