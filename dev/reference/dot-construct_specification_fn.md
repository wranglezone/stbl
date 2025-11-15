# Construct a specified stabilizer function

Construct a specified stabilizer function

## Usage

``` r
.construct_specification_fn(
  check_dupes,
  stabilizer,
  factory_args,
  ...,
  call = rlang::caller_env()
)
```

## Arguments

- check_dupes:

  `(list)` An empty list, or a list containing an expression that checks
  for duplicate arguments.

- stabilizer:

  `(length-1 character)` Name of the stabilizer function to call.

- factory_args:

  Arguments passed to
  [`specify_cls()`](https://stbl.wrangle.zone/dev/reference/specify_cls.md)
  as `...`.

- ...:

  Not used. Included to avoid confusion in R CMD check.

- call:

  `(environment)` The environment to use as the parent of the generated
  function. Defaults to the caller's environment.

## Value

A function of class `"stbl_specified_fn"` that calls the specified
stabilizer function with the provided arguments. The generated function
will also accept `...` for additional arguments to pass to the
stabilizer function. You can copy/paste the body of the resulting
function if you want to provide additional context or functionality.
