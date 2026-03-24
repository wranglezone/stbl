# Error if an object is a primitive function

Error if an object is a primitive function

## Usage

``` r
.check_is_not_primitive(x, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The object to check.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if `x` passes the check.
