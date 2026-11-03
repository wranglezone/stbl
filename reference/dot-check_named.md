# Check the names of an object

Check the names of an object

## Usage

``` r
.check_named(x, named = NULL, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The object to check.

- named:

  Controls the names of `x`. `NULL` (default), `NA`, or `character(0)`
  skip the check. `TRUE` requires every element to have a non-empty
  name; `FALSE` requires that no elements are named. A character vector
  (or factor) requires `x` to be named, with every name in the vector. A
  single stabilizer or conversion function (such as
  [`stabilize_chr()`](https://stbl.wrangle.zone/reference/stabilize_chr.md),
  a `to_*` function, or the result of
  [`specify_chr()`](https://stbl.wrangle.zone/reference/specify_chr.md))
  requires `x` to be named and is applied to `names(x)`, so every name
  must satisfy it.

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
