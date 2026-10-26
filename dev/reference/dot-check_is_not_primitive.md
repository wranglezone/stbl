# Error if an object is a primitive function

Error if an object is a primitive function

## Usage

``` r
.check_is_not_primitive(
  x,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env()
)
```

## Arguments

- x:

  The object to check.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- to_arg:

  (`character(1)` or `NULL`) The name of the object that `x` is being
  coerced to match, for use in error messages. When `NULL`, error
  messages describe only `x`. When supplied, coercion failure messages
  name both `x_arg` and `to_arg`.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` invisibly (called for side effects).
