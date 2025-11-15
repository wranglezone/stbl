# Check for coercion failures and stop if any are found

Check for coercion failures and stop if any are found

## Usage

``` r
.check_cast_failures(failures, x_class, to, due_to, x_arg, call)
```

## Arguments

- failures:

  `(logical)` A logical vector where `TRUE` indicates a coercion
  failure.

- x_class:

  `(length-1 character)` The class name of `x` to use in error messages.
  Use this if you remove a special class from `x` before checking its
  coercion, but want the error message to match the original class.

- to:

  The target object for the coercion.

- due_to:

  `(length-1 character)` A string describing the reason for the failure.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.
