# A wrapper for `glue::glue` with custom delimiters

This wrapper sets the `.open` and `.close` arguments of
[`glue::glue()`](https://glue.tidyverse.org/reference/glue.html) to `[`
and `]`, respectively. This allows for safe use of glue interpolation
within messages that will be processed by
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html),
which uses `{` and `}` for its own styling.

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
