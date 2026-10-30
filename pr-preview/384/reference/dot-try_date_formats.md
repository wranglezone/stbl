# Try candidate date formats against a character vector

Tries each format in `formats`, in order, and returns the first one that
parses every non-`NA` element of `x` without failure. If none succeed
for every element, returns the result of the first format tried, so that
error messages describe a concrete (if incomplete) failure rather than
an arbitrary one.

## Usage

``` r
.try_date_formats(x, formats)
```

## Arguments

- x:

  `(character)` The vector to parse.

- formats:

  `(character)` Candidate
  [`strptime()`](https://rdrr.io/r/base/strptime.html)-style format
  strings, tried in order.

## Value

A list with `parsed` (a [base::Date](https://rdrr.io/r/base/Dates.html)
vector) and `failures` (a logical vector, the same length as `x`, `TRUE`
where an element could not be parsed with the chosen format).
