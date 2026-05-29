# Check for duplicate names in a list

Check for duplicate names in a list

## Usage

``` r
.check_duplicate_names(.x, .allow_duplicate_names, .x_arg, .call)
```

## Arguments

- .x:

  The argument to stabilize.

- .allow_duplicate_names:

  `(length-1 logical)` Should `.x` be allowed to have duplicate names?
  If `FALSE` (default), an error is thrown when any named element of
  `.x` shares a name with another.

- .x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if the check passes.
