# NULL-coalescing-like operator

If the left-hand side is not `NULL`, returns the right-hand side.
Otherwise, returns `NULL`. This is useful for guarding expressions that
should only be executed if a value is not `NULL`. Meant to be similar to
the `%||%` operator (which returns `y` if `x` is `NULL`).

## Usage

``` r
x %&&% y
```

## Arguments

- x:

  The object to check for `NULL`.

- y:

  The value to return if `x` is not `NULL`.

## Value

`NULL` or the value of `y`.
