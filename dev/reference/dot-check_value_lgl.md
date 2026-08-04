# Check logical values against allowed values

Check logical values against allowed values

## Usage

``` r
.check_value_lgl(
  x,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The argument to stabilize.

- allowed_values:

  A vector of permitted values (coerced to the target type). `NULL`
  (default) skips the check. `NA` values in `x` are permitted
  independently of `allowed_values`, subject to `allow_na`.

- x_arg:

  (`character(1)`) The name of the argument being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if `x` passes all checks.
