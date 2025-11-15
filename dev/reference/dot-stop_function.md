# Abort because an argument must not be a function

Abort because an argument must not be a function

## Usage

``` r
.stop_function(x_arg, call)
```

## Arguments

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

This function is called for its side effect of throwing an error and
does not return a value.
