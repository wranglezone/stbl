# Coerce to a function

`to_fn()` coerces `x` to a function. `to_function()` is a synonym of
`to_fn()`.

## Usage

``` r
to_fn(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_function(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_fn(x, ..., allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())

# S3 method for class 'character'
to_fn(
  x,
  ...,
  allow_null = TRUE,
  definition_env = rlang::global_env(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# Default S3 method
to_fn(
  x,
  ...,
  definition_env = rlang::global_env(),
  x_arg = caller_arg(x),
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

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its coercion, but want the error message to
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

- `<stbl-error-coerce-function>` when `x` cannot be coerced to a
  function.

- `<stbl-error-invalid_function_name>` when `x` is not a syntactically
  valid function name.

- `<stbl-error-unknown_function>` when `x` is a syntactically valid name
  that doesn't resolve to a known function.

- `<stbl-error-non_scalar>` when `x` has more than one element.

- `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.

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

## Examples

``` r
to_fn("mean")
#> function (x, ...) 
#> UseMethod("mean")
#> <bytecode: 0x55bd987d0f18>
#> <environment: namespace:base>
to_fn(~ . + 1)
#> <lambda>
#> function (..., .x = ..1, .y = ..2, . = ..1) 
#> . + 1
#> <environment: 0x55bd9e5d5fb8>
#> attr(,"class")
#> [1] "rlang_lambda_function" "function"             
to_fn(mean)
#> function (x, ...) 
#> UseMethod("mean")
#> <bytecode: 0x55bd987d0f18>
#> <environment: namespace:base>
to_fn("stats::median")
#> function (x, na.rm = FALSE, ...) 
#> UseMethod("median")
#> <bytecode: 0x55bd981531a0>
#> <environment: namespace:stats>
to_fn(NULL)
#> NULL
```
