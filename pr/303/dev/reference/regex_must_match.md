# Create a regex matching rule

Attach a standardized error message to a `regex` argument. By default,
the message will be "must match the regex pattern {regex}". If the input
`regex` has a `negate` attribute set to `TRUE` (set automatically by
`regex_must_not_match()`), the message will instead be "must not
match...". This message can be used with
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
and
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md).

## Usage

``` r
regex_must_match(regex)

regex_must_not_match(regex)
```

## Arguments

- regex:

  `(character)` The regular expression pattern.

## Value

For `regex_must_match`, the `regex` value with
[`names()`](https://rdrr.io/r/base/names.html) equal to the generated
error message.

For `regex_must_not_match()`, the `regex` value with a `negate`
attribute and with [`names()`](https://rdrr.io/r/base/names.html) equal
to the generated "must not match" error message.

## Examples

``` r
regex_must_match("[aeiou]")
#> must match the regex pattern {.val [aeiou]} 
#>                                   "[aeiou]" 

# With negation:
regex <- "[aeiou]"
attr(regex, "negate") <- TRUE
regex_must_match(regex)
#> must not match the regex pattern {.val [aeiou]} 
#>                                       "[aeiou]" 
#> attr(,"negate")
#> [1] TRUE
regex_must_not_match("[aeiou]")
#> must not match the regex pattern {.val [aeiou]} 
#>                                       "[aeiou]" 
#> attr(,"negate")
#> [1] TRUE
```
