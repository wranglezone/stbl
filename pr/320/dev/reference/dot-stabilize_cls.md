# Stabilize an object of a specific class

Stabilize an object of a specific class

## Usage

``` r
.stabilize_cls(
  x,
  to_cls_fn,
  ...,
  to_cls_args = list(),
  check_cls_value_fn = NULL,
  check_cls_value_fn_args = list(),
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The argument to stabilize.

- to_cls_fn:

  `(function)` The `to_*()` function to use for coercion.

- ...:

  Arguments passed to methods.

- to_cls_args:

  `(list)` A list of additional arguments to pass to `to_cls_fn()`.

- check_cls_value_fn:

  `(function)` A function to check the values of `x` after coercion.

- check_cls_value_fn_args:

  `(list)` A list of additional arguments to pass to
  `check_cls_value_fn()`.

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- allow_na:

  (`logical(1)`) Are NA values ok?

- min_size:

  (`integer(1)`) The minimum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- max_size:

  (`integer(1)`) The maximum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- unique:

  (`logical(1)`) Should all elements in `x` be distinct?

- x_arg:

  (`character(1)`) The name of the argument being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  (`character(1)`) The class name of the argument being stabilized to
  use in error messages. Use this if you remove a special class from the
  object before checking its coercion, but want the error message to
  match the original class.

## Value

`x` as a vector of the target class with all checks passed.
