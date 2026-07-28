# Stop for bad factor levels

Stop for bad factor levels

## Usage

``` r
.stop_bad_levels(x, bad_casts, levels, to_na, x_arg, call)
```

## Arguments

- x:

  The argument to stabilize.

- bad_casts:

  `(logical)` A logical vector indicating which elements of `x` are not
  in the allowed levels.

- levels:

  `(character)` The desired factor levels.

- to_na:

  `(character)` Values to convert to `NA`.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` invisibly (called for side effects).
