# Convert an object from a complex to a numeric class

Convert an object from a complex to a numeric class

## Usage

``` r
.to_num_from_complex(
  x,
  convert_fn,
  to_type_obj,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The object to stabilize.

- convert_fn:

  `(function)` The `as.*()` function to use for conversion.

- to_type_obj:

  An empty object of the target type (e.g.,
  [`integer()`](https://rdrr.io/r/base/integer.html)).

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

## Value

`x` converted to the target class.
