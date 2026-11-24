# Normalize a list-valued requirements specification

Normalize a list-valued requirements specification

## Usage

``` r
.normalize_required_list(required, required_arg, call)
```

## Arguments

- required:

  `NULL`, a character vector, or a list.

- required_arg:

  (`character(1)`) Name of the argument, for error messages.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

A canonical requirements list.
