# Create a specified stabilizer function

Create a specified stabilizer function

## Usage

``` r
specify_cls(
  stabilizer,
  factory_args = list(),
  scalar = FALSE,
  call = rlang::caller_env()
)
```

## Arguments

- stabilizer:

  `(length-1 character)` Name of the stabilizer function to call.

- factory_args:

  `(list)` Arguments to include in the call to the stabilizer function.

- scalar:

  `(length-1 logical)` Whether to call the scalar version of the
  stabilizer.

- call:

  `(environment)` The environment to use as the parent of the generated
  function. Defaults to the caller's environment.

## Value

A function of class `"stbl_specified_fn"` that calls the specified
stabilizer function with the provided arguments. The generated function
will also accept `...` for additional arguments to pass to the
stabilizer function. You can copy/paste the body of the resulting
function if you want to provide additional context or functionality.
