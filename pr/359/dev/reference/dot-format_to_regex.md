# Convert a strptime()-style format string to a shape-checking regex

Used to verify that a character vector's *shape* matches a candidate
format before handing it to
[`as.Date()`](https://rdrr.io/r/base/as.Date.html), since that function
silently ignores unmatched trailing characters rather than failing.

## Usage

``` r
.format_to_regex(fmt)
```

## Arguments

- fmt:

  (`character(1)`) A
  [`strptime()`](https://rdrr.io/r/base/strptime.html)-style format
  string built from `%Y`, `%m`, `%d`, `%H`, `%M`, and `%S` specifiers
  and literal separators.

## Value

A `character(1)` regular expression, anchored with `^` and `$`, that
matches strings shaped like `fmt`.
