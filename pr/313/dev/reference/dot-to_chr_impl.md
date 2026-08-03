# Internal S3 implementation of to_chr

Internal S3 implementation of to_chr

## Usage

``` r
.to_chr_impl(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The argument to stabilize.

- ...:

  Arguments passed to methods.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  `(length-1 character)` The class name of the argument being stabilized
  to use in error messages. Use this if you remove a special class from
  the object before checking its coercion, but want the error message to
  match the original class.

## Value

The argument coerced to character.
