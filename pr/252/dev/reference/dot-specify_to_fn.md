# Build a pre-configured to_fn() wrapper

Build a pre-configured to_fn() wrapper

## Usage

``` r
.specify_to_fn(factory_args, ..., call = rlang::caller_env())
```

## Arguments

- factory_args:

  `(list)` Arguments to pre-fill in the call to
  [`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md).

- ...:

  Not used. Included to avoid confusion in R CMD check.

- call:

  `(environment)` The environment to use as the parent of the generated
  function. Defaults to the caller's environment.

## Value

A function of class `"stbl_specified_fn"` that calls
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md) with the
provided arguments.
