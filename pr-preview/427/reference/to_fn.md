# Convert to a function

`to_fn()` converts `x` to a function. `to_function()` is a synonym of
`to_fn()`.

## Usage

``` r
to_fn(
  x,
  ...,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
)

to_function(
  x,
  ...,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_fn(
  x,
  ...,
  allow_null = TRUE,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'character'
to_fn(
  x,
  ...,
  allow_null = TRUE,
  definition_env = rlang::global_env(),
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
)

# Default S3 method
to_fn(
  x,
  ...,
  definition_env = rlang::global_env(),
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The object to stabilize.

- ...:

  Arguments passed to methods.

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

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- definition_env:

  `(environment)` The environment in which to look up function name.
  Defaults to
  [`rlang::global_env()`](https://rlang.r-lib.org/reference/search_envs.html).
  This argument is ignored when the input is a namespaced string of the
  form `"pkg::fn"`, in which case the package namespace is used instead.

## Value

A function, or an error condition with classes `<stbl-error>`,
`<stbl-condition>`, `<rlang_error>`, `<error>`, `<condition>`, and a
specific class by failure mode:

- `<stbl-error-bad_null>` for `NULL` values (or length-0 character
  vectors) when `allow_null = FALSE`.

- `<stbl-error-coerce-function>` when `x` cannot be converted to a
  function.

- `<stbl-error-invalid_function_name>` when `x` uses colons other than a
  single `::` between a package name and a function name.

- `<stbl-error-non_scalar>` when `x` has more than one element.

- `<stbl-error-unknown_function>` when `x` doesn't resolve to a known
  function.

## Details

Unlike
[`rlang::as_function()`](https://rlang.r-lib.org/reference/as_function.html),
`to_fn()` supports namespaced function names such as `"pkg::fn"` in the
character method. When the input is a length-0 character vector,
`to_fn()` returns `NULL` (subject to `allow_null`). An input of length
\> 1 is always an error.

## See also

Other function functions:
[`are_fn_ish()`](https://stbl.wrangle.zone/dev/reference/are_fn_ish.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md)

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
[`to_each()`](https://stbl.wrangle.zone/dev/reference/to_each.md),
[`to_fct()`](https://stbl.wrangle.zone/dev/reference/to_fct.md),
[`to_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/to_fct_scalar.md),
[`to_int()`](https://stbl.wrangle.zone/dev/reference/to_int.md),
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/to_int_scalar.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md),
[`to_lst()`](https://stbl.wrangle.zone/dev/reference/to_lst.md),
[`to_time()`](https://stbl.wrangle.zone/dev/reference/to_time.md),
[`to_time_scalar()`](https://stbl.wrangle.zone/dev/reference/to_time_scalar.md)

## Examples

``` r
to_fn("mean")
#> function (x, ...) 
#> UseMethod("mean")
#> <bytecode: 0x59dc8ac309a0>
#> <environment: namespace:base>
to_fn(~ . + 1)
#> <lambda>
#> function (..., .x = ..1, .y = ..2, . = ..1) 
#> . + 1
#> <environment: 0x59dc8c221410>
#> attr(,"class")
#> [1] "rlang_lambda_function" "function"             
to_fn(mean)
#> function (x, ...) 
#> UseMethod("mean")
#> <bytecode: 0x59dc8ac309a0>
#> <environment: namespace:base>
to_fn("stats::median")
#> function (x, na.rm = FALSE, ...) 
#> UseMethod("median")
#> <bytecode: 0x59dc8a5a1b80>
#> <environment: namespace:stats>
to_fn(NULL)
#> NULL
```
