# Check that all elements are members of an allowed set of values

Check that all elements are members of an allowed set of values

## Usage

``` r
.check_allowed_values(
  x,
  allowed_values,
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The object to check.

- allowed_values:

  A vector of permitted values, already coerced to the same type as `x`.
  `NULL` or zero-length skips the check.

- x_arg:

  (`character(1)`) The name of the argument being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` invisibly (called for side effects).
