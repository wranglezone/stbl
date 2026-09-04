# Check double values against min and max values

Check double values against min and max values

## Usage

``` r
.check_value_dbl(
  x,
  min_value,
  max_value,
  exclusive_min_value = NULL,
  exclusive_max_value = NULL,
  allowed_values = NULL,
  multiple_of = NULL,
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

- exclusive_min_value:

  (`numeric(1)`) `x` must be strictly greater than this value (JSON
  Schema `exclusiveMinimum` semantics). `NULL` (default) skips the
  check.

- exclusive_max_value:

  (`numeric(1)`) `x` must be strictly less than this value (JSON Schema
  `exclusiveMaximum` semantics). `NULL` (default) skips the check.

- allowed_values:

  A vector of permitted values (coerced to the target type). `NULL`
  (default) skips the check. `NA` values in `x` are permitted
  independently of `allowed_values`, subject to `allow_na`.

- multiple_of:

  (`numeric(1)`, positive) `x` must be an integer multiple of this
  value. `NULL` (default) skips the check. For doubles, a small relative
  tolerance is applied to avoid floating-point false negatives.

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
