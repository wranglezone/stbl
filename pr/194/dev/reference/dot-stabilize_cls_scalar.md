# Stabilize a scalar object of a specific class

A helper used by the `stabilize_*_scalar()` functions to provide a
standard set of checks.

## Usage

``` r
.stabilize_cls_scalar(
  x,
  to_cls_scalar_fn,
  ...,
  to_cls_scalar_args = list(),
  check_cls_value_fn = NULL,
  check_cls_value_fn_args = list(),
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The argument to stabilize.

- to_cls_scalar_fn:

  `(function)` The `to_*_scalar()` function to use for coercion.

- ...:

  Arguments passed to methods.

- to_cls_scalar_args:

  `(list)` A list of additional arguments to pass to
  `to_cls_scalar_fn()`.

- check_cls_value_fn:

  `(function)` A function to check the values of `x` after coercion.

- check_cls_value_fn_args:

  `(list)` A list of additional arguments to pass to
  `check_cls_value_fn()`.

- allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

- allow_zero_length:

  `(length-1 logical)` Are zero-length vectors acceptable?

- allow_na:

  `(length-1 logical)` Are NA values ok?

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

`x` as a scalar of the target class with all checks passed.
