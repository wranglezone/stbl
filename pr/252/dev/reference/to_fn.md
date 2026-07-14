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
  call = caller_env()
)
```

## Arguments

- x:

  The argument to stabilize.

- ...:

  Arguments passed to methods.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  `(length-1 character)` The class name of the argument being stabilized
  to use in error messages. Use this if you remove a special class from
  the object before checking its coercion, but want the error message to
  match the original class.

- allow_null:

  `(length-1 logical)` Is `NULL` an acceptable return value? When `TRUE`
  (the default), a length-0 character input or a `NULL` input returns
  `NULL`. When `FALSE`, those inputs throw an error.

- definition_env:

  `(environment)` The environment in which to look up function names.
  Defaults to
  [`rlang::global_env()`](https://rlang.r-lib.org/reference/search_envs.html).
  This argument is named `definition_env` to avoid confusion with
  [`rlang::fn_env()`](https://rlang.r-lib.org/reference/fn_env.html),
  which returns the environment *enclosed* by an existing function. This
  argument is ignored when the input is a namespaced string of the form
  `"pkg::fn"`, in which case the package namespace is used instead.

## Value

A function.

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
[`specify_fn()`](https://stbl.wrangle.zone/dev/reference/specify_fn.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md)

## Examples

``` r
to_fn("mean")
#> function (x, ...) 
#> UseMethod("mean")
#> <bytecode: 0x5650d02e0d30>
#> <environment: namespace:base>
to_fn(~ . + 1)
#> <lambda>
#> function (..., .x = ..1, .y = ..2, . = ..1) 
#> . + 1
#> <environment: 0x5650d73932e8>
#> attr(,"class")
#> [1] "rlang_lambda_function" "function"             
to_fn(mean)
#> function (x, ...) 
#> UseMethod("mean")
#> <bytecode: 0x5650d02e0d30>
#> <environment: namespace:base>
to_fn("stats::median")
#> function (x, na.rm = FALSE, ...) 
#> UseMethod("median")
#> <bytecode: 0x5650cfc8c948>
#> <environment: namespace:stats>
to_fn(NULL)
#> NULL
```
