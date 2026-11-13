# Create a names stabilizer function

`specify_names()` creates a function that calls
[`stabilize_names()`](https://stbl.wrangle.zone/dev/reference/stabilize_names.md)
with pre-configured arguments, so the same name checks can be reused.

## Usage

``` r
specify_names(
  ...,
  allowed_names = NULL,
  spec = NULL,
  required = NULL,
  allow_duplicate_names = FALSE
)
```

## Arguments

- ...:

  Arguments passed to methods.

- allowed_names:

  `(character)` The permitted names. If supplied, `x` must be named
  (every element must have a non-empty name), and every name must be in
  this set. `NULL` (default), `NA`, or `character(0)` skip the check.

- spec:

  `(function)` A single stabilizer or conversion function, such as a
  `to_*` function
  ([`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
  etc.), a `stabilize_*` function
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc.), or a function produced by a `specify_*()` call
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc.). If supplied, `x` must be named (every element must have a
  non-empty name), and `spec` is applied to `names(x)`. The result
  becomes the names of the returned object. `NULL` (default) skips the
  check.

- required:

  `(character)` Names that must be present in `x` (after applying
  `spec`, if any). `NULL` (default) or
  [`character()`](https://rdrr.io/r/base/character.html) skip the check.

- allow_duplicate_names:

  (`logical(1)`) Should `x` be allowed to have duplicate names?

## Value

A function that takes `x` (plus `...`, `x_arg`, and `call`) and returns
`x` with stabilized names, or throws the errors described in
[`stabilize_names()`](https://stbl.wrangle.zone/dev/reference/stabilize_names.md).

## See also

Other names functions:
[`stabilize_names()`](https://stbl.wrangle.zone/dev/reference/stabilize_names.md)

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
[`specify_lst_positional()`](https://stbl.wrangle.zone/dev/reference/specify_lst_positional.md),
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md),
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_snake_names <- specify_names(
  spec = specify_chr(regex = "^[a-z_]+$"),
  required = "id"
)
stabilize_snake_names(c(id = 1, value_a = 2))
#>      id value_a 
#>       1       2 
try(stabilize_snake_names(c(id = 1, ValueA = 2)))
#> Error in eval(expr, envir) : 
#>   `names(c(id = 1, ValueA = 2))` must match the regex pattern "^[a-z_]+$"
#> ✖ Some values fail the check.
#> ✖ Location: 2
#> ✖ Value: ValueA
```
