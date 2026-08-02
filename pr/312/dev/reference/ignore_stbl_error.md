# Ignore a stbl error and return NULL

Catches a `{stbl}` error with the specified `subclass` and silently
returns `NULL`. Other errors (including other `{stbl}` errors) are not
caught and will propagate normally.

## Usage

``` r
ignore_stbl_error(expr, subclass)
```

## Arguments

- expr:

  An expression to evaluate.

- subclass:

  (`character`) The subclass(es) of the `{stbl}` error to ignore.
  Combined with `"stbl-error-"` to form the class name to intercept. For
  example, `c("coerce", "character")` silences errors of class
  `stbl-error-coerce-character`, while `c("coerce")` silences any
  `stbl-error-coerce` error.

## Value

The result of `expr` if no matching error is thrown, or `NULL` if a
matching `{stbl}` error is caught.

## Details

The `subclass` argument mirrors the subclass hierarchy used when the
error was originally thrown. For example, an error with class
`stbl-error-coerce-character` is caught with
`subclass = c("coerce", "character")`. Any `coerce` error (regardless of
the target type) is caught with `subclass = c("coerce")`. Similarly,
`stbl-error-incompatible_values-integer` is caught with
`subclass = c("incompatible_values", "integer")`.

## Examples

``` r
ignore_stbl_error(to_chr(data.frame()), subclass = c("coerce", "character"))
#> NULL
ignore_stbl_error(to_chr("hello"), subclass = c("coerce", "character"))
#> [1] "hello"
```
