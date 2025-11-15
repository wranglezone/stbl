# Coerce an object to a specific scalar class

A helper that wraps around a `to_*_scalar()` function to provide a
standard set of checks.

## Usage

``` r
.to_cls_scalar(
  x,
  is_rlang_cls_scalar,
  to_cls_fn,
  to_cls_args = list(),
  allow_null = TRUE,
  allow_zero_length = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The argument to stabilize.

- is_rlang_cls_scalar:

  `(function)` An `is_scalar_*()` function from rlang, used for a fast
  path if `x` is already the right type.

- to_cls_fn:

  `(function)` The `to_*()` function to use for coercion.

- to_cls_args:

  `(list)` A list of additional arguments to pass to `to_cls_fn()`.

- allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

- allow_zero_length:

  `(length-1 logical)` Are zero-length vectors acceptable?

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  `(length-1 character)` The class name of `x` to use in error messages.
  Use this if you remove a special class from `x` before checking its
  coercion, but want the error message to match the original class.

## Value

`x` as a scalar of the target class.
