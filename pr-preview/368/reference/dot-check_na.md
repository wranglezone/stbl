# Check for NA values

Check for NA values

## Usage

``` r
.check_na(x, allow_na = TRUE, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The object to check.

- allow_na:

  (`logical(1)`) Are NA values ok?

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` invisibly (called for side effects).
