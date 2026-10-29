# Check that `to_arg` is `NULL` or a single string

Check that `to_arg` is `NULL` or a single string

## Usage

``` r
.check_to_arg(to_arg, call = caller_env())
```

## Arguments

- to_arg:

  (`character(1)` or `NULL`) The name of the object that `x` is being
  converted to match, for use in error messages. When `NULL`, error
  messages describe only `x`. When supplied, conversion failure messages
  name both `x_arg` and `to_arg`.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`to_arg`, unchanged, or an error if it is not `NULL` or a string.
