# Call the C routine that reconciles equivalent values

Call the C routine that reconciles equivalent values

## Usage

``` r
.reconcile(values)
```

## Arguments

- values:

  `(list)` At least one value.

## Value

A list with two elements. `result` is the narrowest common
representation of `values`, and `mismatch` is `NULL`, if every value is
equivalent to every other value. Otherwise `result` is `NULL` and
`mismatch` is a list with the positions `i` and `j` of the first pair of
values that disagree, the positions `at` of the first difference inside
lists and data frames, and an integer `reason` code (see `stbl.h`).
