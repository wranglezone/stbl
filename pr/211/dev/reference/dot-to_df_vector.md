# Coerce a vector to a one-column data frame

Called by `to_df.*` methods for atomic vector types. Succeeds only when
`x` was supplied as a named symbol (variable), not as an inline
expression. This prevents data frames with syntactically ugly column
names.

## Usage

``` r
.to_df_vector(x, x_expr, x_arg, call, x_class, ...)
```

## Arguments

- x:

  The argument to stabilize.

- x_expr:

  `(language)` The unevaluated expression for `x`, captured via
  `substitute(x)` in the calling method.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  `(length-1 character)` The class name of the argument being stabilized
  to use in error messages. Use this if you remove a special class from
  the object before checking its coercion, but want the error message to
  match the original class.

- ...:

  Arguments passed to methods.

## Value

A one-column data frame.
