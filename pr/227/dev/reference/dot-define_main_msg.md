# Define the main error message for a "must" error

Define the main error message for a "must" error

## Usage

``` r
.define_main_msg(x_arg, msg)
```

## Arguments

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- msg:

  `(character)` The core error message describing the requirement.

## Value

A character string.
