# Deprecated: use `assert_present()` instead

`stabilize_present()` was renamed to
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md)
because it doesn't stabilize (coerce) `x` in any way; it only asserts
that `x` is not `NULL`. Calling `stabilize_present()` now throws an
error directing you to
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md)
instead.

## Usage

``` r
stabilize_present(x, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The argument to stabilize.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

This function does not return a value; it always throws an error
condition with classes `<stbl-error-deprecated>`, `<stbl-error>`,
`<stbl-condition>`, `<rlang_error>`, `<error>`, and `<condition>`.
