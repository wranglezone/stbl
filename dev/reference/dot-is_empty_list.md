# Test for an empty, unclassed list

Empty lists (such as an empty JSON array parsed by jsonlite) are treated
as empty vectors by the `to_*()` functions. Classed lists (including
data frames) are not considered.

## Usage

``` r
.is_empty_list(x)
```

## Arguments

- x:

  The object to test.

## Value

`TRUE` if `x` is a zero-length list without a class attribute, else
`FALSE`.
