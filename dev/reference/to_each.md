# Convert each element of x with a single spec

`to_each()` applies `spec` (a `to_*` function, `stabilize_*` function,
or `specify_*()` result) to every element of `x`, and stops at the first
element that fails.

## Usage

``` r
to_each(
  x,
  spec,
  ...,
  simplify = TRUE,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = NULL
)
```

## Arguments

- x:

  The object to stabilize.

- spec:

  `(function)` A single stabilizer or conversion function, such as a
  `to_*` function
  ([`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
  etc.), a `stabilize_*` function
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc.), or a function produced by a `specify_*()` call
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc.). Applied independently to each element of `x`.

- ...:

  Arguments passed to methods.

- simplify:

  (`logical(1)`) Should per-element results be combined into a single
  atomic vector when possible (every result has size 1 and shares a
  common type)? If `FALSE`, a list is always returned.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- to_arg:

  (`character(1)` or `NULL`) The name of the object that `x` is being
  converted to match, for use in error messages. When `NULL`, error
  messages describe only `x`. When supplied, conversion failure messages
  name both `x_arg` and `to_arg`.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its conversion, but want the error message to
  match the original class.

## Value

`x` with every element converted by `spec`, simplified to an atomic
vector when `simplify = TRUE` and possible, otherwise a list. Errors
with whatever condition `spec` throws for the first failing element.

## See also

Other multiple type functions:
[`reconcile()`](https://stbl.wrangle.zone/dev/reference/reconcile.md),
[`specify_all_of()`](https://stbl.wrangle.zone/dev/reference/specify_all_of.md),
[`specify_any_of()`](https://stbl.wrangle.zone/dev/reference/specify_any_of.md),
[`specify_each()`](https://stbl.wrangle.zone/dev/reference/specify_each.md),
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md),
[`stabilize_all_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_all_of.md),
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md),
[`stabilize_each()`](https://stbl.wrangle.zone/dev/reference/stabilize_each.md),
[`stabilize_one_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_one_of.md)

Other stabilization functions:
[`assert_contains()`](https://stbl.wrangle.zone/dev/reference/assert_contains.md),
[`assert_not()`](https://stbl.wrangle.zone/dev/reference/assert_not.md),
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`stabilize_all_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_all_of.md),
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md),
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr_scalar.md),
[`stabilize_date()`](https://stbl.wrangle.zone/dev/reference/stabilize_date.md),
[`stabilize_date_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_date_scalar.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl_scalar.md),
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md),
[`stabilize_dttm()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm.md),
[`stabilize_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm_scalar.md),
[`stabilize_dur()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur.md),
[`stabilize_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur_scalar.md),
[`stabilize_each()`](https://stbl.wrangle.zone/dev/reference/stabilize_each.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct_scalar.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md),
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`stabilize_lst_positional()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst_positional.md),
[`stabilize_names()`](https://stbl.wrangle.zone/dev/reference/stabilize_names.md),
[`stabilize_one_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_one_of.md),
[`stabilize_time()`](https://stbl.wrangle.zone/dev/reference/stabilize_time.md),
[`stabilize_time_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_time_scalar.md),
[`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
[`to_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/to_chr_scalar.md),
[`to_date()`](https://stbl.wrangle.zone/dev/reference/to_date.md),
[`to_date_scalar()`](https://stbl.wrangle.zone/dev/reference/to_date_scalar.md),
[`to_dbl()`](https://stbl.wrangle.zone/dev/reference/to_dbl.md),
[`to_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dbl_scalar.md),
[`to_df()`](https://stbl.wrangle.zone/dev/reference/to_df.md),
[`to_dttm()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md),
[`to_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dttm_scalar.md),
[`to_dur()`](https://stbl.wrangle.zone/dev/reference/to_dur.md),
[`to_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dur_scalar.md),
[`to_fct()`](https://stbl.wrangle.zone/dev/reference/to_fct.md),
[`to_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/to_fct_scalar.md),
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md),
[`to_int()`](https://stbl.wrangle.zone/dev/reference/to_int.md),
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/to_int_scalar.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md),
[`to_lst()`](https://stbl.wrangle.zone/dev/reference/to_lst.md),
[`to_time()`](https://stbl.wrangle.zone/dev/reference/to_time.md),
[`to_time_scalar()`](https://stbl.wrangle.zone/dev/reference/to_time_scalar.md)

## Examples

``` r
to_each(list("1", "2", "3"), to_int)
#> [1] 1 2 3
to_each(list(1L, 2L, 3L), to_chr)
#> [1] "1" "2" "3"

# Elements that can't be simplified into a common type stay a list
to_each(list(1L, "a"), specify_any_of(stabilize_int, stabilize_chr))
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] "a"
#> 

# Stops at the first element that fails
try(to_each(list("1", "a"), to_int))
#> Error in eval(expr, envir) : 
#>   `list("1", "a")[[2]]` <character> must be convertible to <integer>
#> ✖ Can't convert some values due to non-numeric strings.
#> • Locations: 1
#> • Values: "a"
```
