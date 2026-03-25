# Check for character to integer coercion failures

Check for character to integer coercion failures

## Usage

``` r
.check_chr_to_int_failures(x, x_class, x_arg, call)
```

## Arguments

- x:

  The argument to stabilize.

- x_class:

  `(length-1 character)` The class name of `x` to use in error messages.
  Use this if you remove a special class from `x` before checking its
  coercion, but want the error message to match the original class.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if `x` passes all checks.
