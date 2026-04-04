# Check that list elements do not have jagged (unequal non-1) lengths

Expected to be called after
[`.check_all_named()`](https://stbl.wrangle.zone/reference/dot-check_all_named.md),
so `names(x)` is guaranteed to be non-`NULL`. Length-1 elements are
excluded from the check because they recycle to any length in
[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

## Usage

``` r
.check_not_jagged(
  x,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
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

- x_class:

  `(length-1 character)` The class name of the argument being stabilized
  to use in error messages. Use this if you remove a special class from
  the object before checking its coercion, but want the error message to
  match the original class.

## Value

`NULL`, invisibly, if the list is not jagged.
