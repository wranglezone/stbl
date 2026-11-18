# Detect a regex in a character vector

Uses ICU regular expressions (via stringi) when available, because they
support lookarounds, named groups, and `\\p{}` classes that are common
in ECMAScript-style patterns. Falls back to
[`grepl()`](https://rdrr.io/r/base/grep.html) otherwise.

## Usage

``` r
.detect_regex(x, regex)
```

## Arguments

- x:

  `(character)` Values to search.

- regex:

  `(character(1))` The regular expression.

## Value

A logical vector the length of `x` (`NA` where `x` is `NA`).
