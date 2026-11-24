# Ignore a stbl error class

Silences a `stbl` error with the specified `subclass`. Other errors
(including other `stbl` errors) are not caught and propagate normally.
See the documentation of each `stabilize_*()` or `to_*()` function for
the types of errors it throws.

## Usage

``` r
ignore_stbl_error(expr, subclass = character())
```

## Arguments

- expr:

  An expression to evaluate.

- subclass:

  (`character`) The subclass(es) of the `stbl` error to ignore or
  replace. Combined with `"stbl-error"` to form the class name to
  intercept. For example, `c("coerce", "character")` catches errors of
  class `stbl-error-coerce-character`
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)),
  `c("coerce")` catches any `stbl-error-coerce` error, and
  [`character()`](https://rdrr.io/r/base/character.html) (the default)
  catches any `stbl` error.

## Value

The result of `expr` if no matching error is thrown, or `NULL` if a
matching `stbl` error is caught.

## Examples

``` r
ignore_stbl_error(to_chr(data.frame()), subclass = c("coerce", "character"))
#> NULL
ignore_stbl_error(to_chr("hello"), subclass = c("coerce", "character"))
#> [1] "hello"

# Omit subclass to catch any stbl error
ignore_stbl_error(to_chr(data.frame()))
#> NULL
```
