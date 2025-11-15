# Coerce an object from a factor to a specific class

A helper that wraps around a `to_*()` function to provide a standard way
to coerce factors.

## Usage

``` r
.to_cls_from_fct(
  x,
  to_cls_fn,
  to_cls_args,
  to_class,
  coerce_factor = TRUE,
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

- to_cls_args:

  `(list)` A list of additional arguments to pass to `to_cls_fn()`.

- to_class:

  `(length-1 character)` The name of the class to coerce to.

- coerce_factor:

  `(length-1 logical)` Should factors with values such as "1" and "2.0"
  be considered numeric-ish? Note that this package uses the character
  value from the factor, while
  [`as.integer()`](https://rdrr.io/r/base/integer.html) and
  [`as.double()`](https://rdrr.io/r/base/double.html) use the integer
  index of the factor.

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
