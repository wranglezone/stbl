# Check that all names are in a set of allowed names

Check that all names are in a set of allowed names

## Usage

``` r
.check_allowed_names(x, allowed_names, x_arg, call)
```

## Arguments

- x:

  The object to check.

- allowed_names:

  `(character)` The permitted names.

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
