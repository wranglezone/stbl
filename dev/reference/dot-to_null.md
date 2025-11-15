# Ensure an argument is NULL

If `allow_null` is `TRUE`, coerce `x` to `NULL`. Otherwise throw an
informative error.

## Usage

``` r
.to_null(x, allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The argument to stabilize.

- allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` or an error.
