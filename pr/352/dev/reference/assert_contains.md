# Require that x contains a number of elements matching a specification

`assert_contains()` applies `spec` to each element of `x` independently
and counts how many elements match. It returns `x` unchanged if that
count falls between `min_matches` and `max_matches` (inclusive), and
errors otherwise.

## Usage

``` r
assert_contains(
  x,
  spec,
  ...,
  min_matches = 1,
  max_matches = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The object to stabilize.

- spec:

  `(function)` A single stabilizer or coercion function, such as a
  `to_*` function
  ([`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
  etc.), a `stabilize_*` function
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc.), or a function produced by a `specify_*()` call
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc.). Applied independently to each element of `x`.

- ...:

  Arguments passed to methods.

- min_matches:

  (`integer(1)`) The minimum number of elements of `x` that must match
  `spec`. Must be `>= 0`. Set to `0` (with non-`NULL` `max_matches` to
  check only an upper bound on the number of matches.

- max_matches:

  (`integer(1)` or `NULL`) The maximum number of elements of `x` that
  may match `spec`. Must be `>= min_matches`. `NULL` (default) skips the
  upper-bound check.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its coercion, but want the error message to
  match the original class.

## Value

`x`, unchanged, if the number of elements of `x` matching `spec` is
between `min_matches` and `max_matches`, or an error condition with
classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
`<condition>`, and a specific class by failure mode:

- `<stbl-error-too_few_matches>` when fewer than `min_matches` elements
  match `spec`.

- `<stbl-error-too_many_matches>` when more than `max_matches` elements
  match `spec`.

## See also

Other stabilization functions:
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
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct_scalar.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md),
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`stabilize_one_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_one_of.md),
[`stabilize_time()`](https://stbl.wrangle.zone/dev/reference/stabilize_time.md),
[`stabilize_time_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_time_scalar.md),
[`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
[`to_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/to_chr_scalar.md),
[`to_date()`](https://stbl.wrangle.zone/dev/reference/to_date.md),
[`to_date_scalar()`](https://stbl.wrangle.zone/dev/reference/to_date_scalar.md),
[`to_dbl()`](https://stbl.wrangle.zone/dev/reference/to_dbl.md),
[`to_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dbl_scalar.md),
[`to_dttm()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md),
[`to_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dttm_scalar.md),
[`to_dur()`](https://stbl.wrangle.zone/dev/reference/to_dur.md),
[`to_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dur_scalar.md),
[`to_fct()`](https://stbl.wrangle.zone/dev/reference/to_fct.md),
[`to_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/to_fct_scalar.md),
[`to_int()`](https://stbl.wrangle.zone/dev/reference/to_int.md),
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/to_int_scalar.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md),
[`to_time()`](https://stbl.wrangle.zone/dev/reference/to_time.md),
[`to_time_scalar()`](https://stbl.wrangle.zone/dev/reference/to_time_scalar.md)

## Examples

``` r
# By default, at least 1 element must match spec
assert_contains(list("1", "a", "b"), stabilize_int)
#> [[1]]
#> [1] "1"
#> 
#> [[2]]
#> [1] "a"
#> 
#> [[3]]
#> [1] "b"
#> 

# Require at least 2 matching elements
assert_contains(list("1", "2", "a"), stabilize_int, min_matches = 2)
#> [[1]]
#> [1] "1"
#> 
#> [[2]]
#> [1] "2"
#> 
#> [[3]]
#> [1] "a"
#> 

# Errors because no elements are int-ish
try(assert_contains(list("a", "b"), stabilize_int))
#> Error in eval(expr, envir) : 
#>   `list("a", "b")` <list> must contain at least 1 element matching `spec`.
#> ✖ Found 0 matching elements.

# Errors because too many elements are int-ish
try(assert_contains(list("1", "2", "3"), stabilize_int, max_matches = 2))
#> Error in eval(expr, envir) : 
#>   `list("1", "2", "3")` <list> must contain at most 2 elements matching
#> `spec`.
#> ✖ Found 3 matching elements.

# spec is applied to each element, not to x as a whole, so a scalar spec
# like stabilize_int_scalar() still matches every element of a list
assert_contains(
  list(1L, 2L, 3L),
  stabilize_int_scalar,
  min_matches = 2,
  max_matches = 3
)
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 2
#> 
#> [[3]]
#> [1] 3
#> 

# Use min_matches = 0 to check only an upper bound on the number of matches
 assert_contains(
   list("1", "a", "b"),
   stabilize_int,
   min_matches = 0,
   max_matches = 1
 )
#> [[1]]
#> [1] "1"
#> 
#> [[2]]
#> [1] "a"
#> 
#> [[3]]
#> [1] "b"
#> 
```
