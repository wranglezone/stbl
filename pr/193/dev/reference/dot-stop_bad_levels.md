# Stop for bad factor levels

Throws a standardized error when values are not found in the provided
factor levels.

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

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

This function is called for its side effect of throwing an error and
does not return a value.
