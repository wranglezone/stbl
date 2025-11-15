# Escape curly braces for safe printing with cli

Replaces single curly braces (`{`, `}`) with double curly braces (`{{`,
`}}`) so that they are interpreted as literal characters by
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html) and
not as expressions to be evaluated.

## Usage

``` r
.cli_escape(msg)
```

## Arguments

- msg:

  `(character)` The messages to escape.

## Value

The messages with curly braces escaped.
