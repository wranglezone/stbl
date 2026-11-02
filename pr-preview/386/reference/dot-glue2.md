# A wrapper for `glue::glue` with bracket delimiters

A wrapper for
[`glue::glue`](https://glue.tidyverse.org/reference/glue.html) with
bracket delimiters

## Usage

``` r
.glue2(..., env = caller_env())
```

## Arguments

- ...:

  Arguments passed on to
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html).
  Usually expects unnamed arguments but named arguments other than
  `.envir`, `.open`, and `.close` are acceptable.

- env:

  The environment in which to evaluate the expressions.

## Value

A character string with evaluated expressions.
