# Check whether functions are allowed

Check whether functions are allowed

## Usage

``` r
.check_function_allowed(
  x,
  coerce_function = FALSE,
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The object to check.

- coerce_function:

  (`logical(1)`) Should functions be coerced?

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
