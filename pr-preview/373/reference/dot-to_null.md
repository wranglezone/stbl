# Ensure an object is NULL

Ensure an object is NULL

## Usage

``` r
.to_null(x, allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The object to stabilize.

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` or an error.
