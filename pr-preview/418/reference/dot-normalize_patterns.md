# Validate a `.patterns` argument

Validate a `.patterns` argument

## Usage

``` r
.normalize_patterns(patterns, patterns_arg, call)
```

## Arguments

- patterns:

  A named list of stabilizers, or `NULL`.

- patterns_arg:

  (`character(1)`) Name of the argument, for messages.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`patterns`, with `NULL` converted to an empty list.
