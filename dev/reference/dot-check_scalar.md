# Check if an object is a scalar

Checks if an object is a scalar, allowing for `NULL` and zero-length
vectors if specified.

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

`NULL`, invisibly, if `x` passes the check.
