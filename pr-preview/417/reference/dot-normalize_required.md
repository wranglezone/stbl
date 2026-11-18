# Normalize a `required`/`.required` specification

Converts the accepted forms of a requirements argument (`NULL`, a
character vector, or a list with unnamed entries for unconditional
requirements and named entries for conditional requirements) into a
canonical nested list with elements `always` (`character`) and `when` (a
named list of canonical specifications keyed by trigger). Named atomic
vectors are treated like the equivalent list. Duplicate triggers are
merged by union.

## Usage

``` r
.normalize_required(required, required_arg, call)
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
