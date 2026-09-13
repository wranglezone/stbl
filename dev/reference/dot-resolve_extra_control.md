# Resolve a `.named`/`.unnamed`-style extra-element control argument

Normalizes the three accepted forms of an extra-element control argument
(`NULL`/`FALSE` to forbid, `TRUE` to allow unchecked, or a stabilizer
function to validate) into either `NULL` (forbid), `TRUE` (allow), or
the stabilizer function (validate).

## Usage

``` r
.resolve_extra_control(control, control_arg, call)
```

## Arguments

- control:

  `NULL`, `TRUE`, `FALSE`, or a stabilizer function.

- control_arg:

  (`character(1)`) Name of the argument being resolved, used in error
  messages if `control` can't be coerced to logical.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, `TRUE`, or a stabilizer function.
