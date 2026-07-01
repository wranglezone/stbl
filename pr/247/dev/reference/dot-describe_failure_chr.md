# Describe a character-based validation failure

Describe a character-based validation failure

## Usage

``` r
.describe_failure_chr(x, success, negate = FALSE)
```

## Arguments

- x:

  The argument to stabilize.

- success:

  `(logical)` A logical vector indicating which elements of `x` passed
  the check.

- negate:

  `(length-1 logical)` Was the check a negative one?

## Value

A named character vector to be used as `additional_msg` in
[`.stop_must()`](https://stbl.wrangle.zone/dev/reference/dot-stop_must.md).
