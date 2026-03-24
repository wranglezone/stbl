# Check for NA values

Checks for `NA` values in `x`, throwing an error if any are found and
`allow_na` is `FALSE`.

## Usage

``` r
.check_na(x, allow_na = TRUE, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The object to check.

- allow_na:

  `(length-1 logical)` Are NA values ok?

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if `x` passes the check.
