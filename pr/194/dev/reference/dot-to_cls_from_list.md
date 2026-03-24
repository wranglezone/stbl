# Coerce a list to a specific class

Coerce a list to a specific class

## Usage

``` r
.to_cls_from_list(
  x,
  to_cls_fn,
  to_class,
  ...,
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

- to_class:

  `(length-1 character)` The name of the class to coerce to.

- ...:

  Arguments passed to methods.

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
