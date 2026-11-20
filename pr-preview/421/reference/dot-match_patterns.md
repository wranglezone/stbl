# Find which patterns match each name

Find which patterns match each name

## Usage

``` r
.match_patterns(nms, patterns)
```

## Arguments

- nms:

  `(character)` Names to match. Empty names never match.

- patterns:

  `(list)` Normalized `.patterns`.

## Value

A logical matrix with a row per name and a column per pattern.
