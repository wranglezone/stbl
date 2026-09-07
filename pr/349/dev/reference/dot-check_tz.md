# Check that a time zone is valid

Check that a time zone is valid

## Usage

``` r
.check_tz(tz, x_arg = "tz", call = caller_env())
```

## Arguments

- tz:

  (`character(1)`) The time zone to validate.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`tz`, coerced to a scalar character, if it is valid.
