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
  named = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The object to stabilize.

- to_cls_fn:

  `(function)` The `to_*()` function to use for conversion.

- ...:

  Arguments passed to methods.

- to_cls_args:

  `(list)` A list of additional arguments to pass to `to_cls_fn()`.

- check_cls_value_fn:

  `(function)` A function to check the values of `x` after conversion.

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

- named:

  Controls the names of `x`. `NULL` (default), `NA`, or `character(0)`
  skip the check. `TRUE` requires every element to have a non-empty
  name; `FALSE` requires that no elements are named. A character vector
  (or factor) requires `x` to be named, with every name in the vector. A
  single stabilizer or conversion function (such as
  [`stabilize_chr()`](https://stbl.wrangle.zone/reference/stabilize_chr.md),
  a `to_*` function, or the result of
  [`specify_chr()`](https://stbl.wrangle.zone/reference/specify_chr.md))
  requires `x` to be named and is applied to `names(x)`, so every name
  must satisfy it.

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
  object before checking its conversion, but want the error message to
  match the original class.

## Value

`x` as a vector of the target class with all checks passed.
