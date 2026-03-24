# Apply a single regex rule to a character vector

Apply a single regex rule to a character vector

## Usage

``` r
.apply_regex_rule(rule, x, x_arg, call)
```

## Arguments

- rule:

  `(length-1 character)` A regex rule (possibly with a `name` and
  `negate` attribute).

- x:

  The argument to stabilize.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

A character vector of error messages if the rule fails, otherwise
`NULL`.
