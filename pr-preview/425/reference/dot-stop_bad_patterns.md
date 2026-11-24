# Abort because `.patterns` is invalid

Abort because `.patterns` is invalid

## Usage

``` r
.stop_bad_patterns(msg, kind, patterns_arg, call, detail = NULL)
```

## Arguments

- msg:

  (`character(1)`) The problem, appended to the argument name.

- kind:

  (`character(1)`) Error subclass added after `"bad_patterns"`.

- patterns_arg:

  (`character(1)`) Name of the argument, for messages.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- detail:

  (`character(1)` or `NULL`) Optional extra bullet describing the
  offending values.

## Value

Does not return; always throws an error.
