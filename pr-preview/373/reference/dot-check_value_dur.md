# Check duration values against min, max, and allowed values

`min_value`, `max_value`, and `allowed_values` are coerced to
[lubridate::Period](https://lubridate.tidyverse.org/reference/Period-class.html)
first so that character or numeric bounds are accepted.

## Usage

``` r
.check_value_dur(
  x,
  min_value,
  max_value,
  allowed_values = NULL,
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The object to stabilize.

- min_value:

  (`numeric(1)`) The lowest allowed value for `x`. If `NULL` (default)
  values are not checked.

- max_value:

  (`numeric(1)`) The highest allowed value for `x`. If `NULL` (default)
  values are not checked.

- allowed_values:

  A vector of permitted values (coerced to the target type). `NULL`
  (default) skips the check. `NA` values in `x` are permitted
  independently of `allowed_values`, subject to `allow_na`.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if `x` passes all checks.
