# Detect a regex pattern in a character vector

A wrapper around
[`stringi::stri_detect_regex()`](https://rdrr.io/pkg/stringi/man/stri_detect.html)
and [`base::grepl()`](https://rdrr.io/r/base/grep.html) that prefers the
`stringi` implementation if the package is available.

## Usage

``` r
.has_regex_pattern(x, regex)
```

## Arguments

- x:

  The argument to stabilize.

- regex:

  `(character, list, or stringr_pattern)` One or more optional regular
  expressions to test against the values of `x`. This can be a character
  vector, a list of character vectors, or a pattern object from the
  {stringr} package (e.g., `stringr::fixed("a.b")`). The default error
  message for non-matching values will include the pattern itself (see
  [`regex_must_match()`](https://stbl.wrangle.zone/dev/reference/regex_must_match.md)).
  To provide a custom message, supply a named character vector where the
  value is the regex pattern and the name is the message that should be
  displayed. To check that a pattern is *not* matched, attach a `negate`
  attribute set to `TRUE`. If a complex regex pattern throws an error,
  try installing the stringi package.

## Value

A logical vector of matches in `x` to `regex`.
