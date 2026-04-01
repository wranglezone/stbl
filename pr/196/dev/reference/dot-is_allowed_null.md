# Check if a value is NULL and NULLs are allowed

Check if a value is NULL and NULLs are allowed

## Usage

``` r
.is_allowed_null(x, allow_null = TRUE, call = caller_env())
```

## Arguments

- x:

  The object to check.

- allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`(length-1 logical)` `TRUE` if `x` is `NULL` and `allow_null` is `TRUE`.
