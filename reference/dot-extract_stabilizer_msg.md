# Extract a summary line from a stabilizer error condition

Returns the first line of the condition message. If the condition
carries a `"Locations:"` bullet in its `body` (as set by
[`.stop_incompatible()`](https://stbl.wrangle.zone/dev/reference/dot-stop_incompatible.md)),
that text is appended in parentheses so callers can see which elements
failed.

## Usage

``` r
.extract_stabilizer_msg(e)
```

## Arguments

- e:

  An error condition.

## Value

A single character string.
