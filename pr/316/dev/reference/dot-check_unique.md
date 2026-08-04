# Check that all elements are unique

Check that all elements are unique

## Usage

``` r
.check_unique(x, unique = FALSE, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The object to check.

- unique:

  `(length-1 logical)` Should all elements in `x` be distinct?

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` invisibly (called for side effects).
