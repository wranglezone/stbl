# Apply a single regex rule to a character vector

Apply a single regex rule to a character vector

## Usage

``` r
.apply_regex_rule(rule, x, x_arg, call)
```

## Arguments

- rule:

  (`character(1)`) A regex rule (possibly with a `name` and `negate`
  attribute).

- x:

  The argument to stabilize.

- x_arg:

  (`character(1)`) The name of the argument being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

A list with a `message` character vector and integer `locations` of the
failing elements if the rule fails, otherwise `NULL`.
