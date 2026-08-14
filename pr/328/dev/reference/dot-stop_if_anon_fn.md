# Error if a function expression is anonymous (not a symbol)

Error if a function expression is anonymous (not a symbol)

## Usage

``` r
.stop_if_anon_fn(x_expr, x_class, x_arg, call)
```

## Arguments

- x_expr:

  The expression from the quosure.

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its coercion, but want the error message to
  match the original class.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.
