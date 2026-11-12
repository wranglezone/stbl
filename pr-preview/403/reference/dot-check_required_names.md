# Check that required names are present

Check that required names are present

## Usage

``` r
.check_required_names(
  x,
  required = NULL,
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The object to check.

- required:

  `(character)` Names that must be present in `x`.

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
