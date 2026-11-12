# Abort because a time zone isn't valid

Abort because a time zone isn't valid

## Usage

``` r
.stop_bad_tz(tz, is_local, x_arg, call)
```

## Arguments

- tz:

  (`character(1)`) The invalid time zone, possibly `NA`.

- is_local:

  (`logical(1)`) Was `tz` found by looking up the local time zone?

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` invisibly (called for side effects).
