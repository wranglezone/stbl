# Check that required column names are present in a data frame

Check that required column names are present in a data frame

## Usage

``` r
.check_df_col_names(.x, col_names, x_arg, call)
```

## Arguments

- .x:

  `(data.frame)` The data frame being validated.

- col_names:

  `(character)` Column names that must be present in `.x`, or `NULL` to
  skip this check.

- x_arg:

  `(length-1 character)` An argument name for `x`. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if the check passes.
