# Coerce an object from a complex to a numeric class

A helper that wraps around a `to_*()` function to provide a standard way
to coerce complex numbers.

## Usage

``` r
.to_num_from_complex(
  x,
  cast_fn,
  to_type_obj,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The argument to stabilize.

- cast_fn:

  `(function)` The `as.*()` function to use for coercion.

- to_type_obj:

  An empty object of the target type (e.g.,
  [`integer()`](https://rdrr.io/r/base/integer.html)).

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

`x` coerced to the target class.
