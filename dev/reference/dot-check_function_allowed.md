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

  `(length-1 logical)` Should functions be coerced?

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if `x` passes the check.
