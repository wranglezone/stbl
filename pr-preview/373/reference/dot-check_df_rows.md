# Check that a data frame has an acceptable number of rows

Check that a data frame has an acceptable number of rows

## Usage

``` r
.check_df_rows(.x, min_rows, max_rows, x_arg, call)
```

## Arguments

- .x:

  `(data.frame)` The data frame being validated.

- min_rows:

  (`integer(1)`) Minimum number of rows allowed, or `NULL` to skip this
  check.

- max_rows:

  (`integer(1)`) Maximum number of rows allowed, or `NULL` to skip this
  check.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if the check passes.
