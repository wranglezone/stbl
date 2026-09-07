# Safely find failure locations in a vector

Safely find failure locations in a vector

## Usage

``` r
.find_failures(x, check_value, check_fn)
```

## Arguments

- x:

  The vector to check.

- check_value:

  The value to check against (e.g., a regex pattern). If `NULL`, the
  check is skipped.

- check_fn:

  The function to use for checking.

## Value

An integer vector of failure locations, or `NULL` if there are no
failures or the check is skipped.
