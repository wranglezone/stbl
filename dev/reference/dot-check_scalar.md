# Check if an object is a scalar

Check if an object is a scalar

## Usage

``` r
.check_scalar(
  x,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The object to check.

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- allow_zero_length:

  (`logical(1)`) Are zero-length vectors acceptable?

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

## Value

`NULL` invisibly (called for side effects).
