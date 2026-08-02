# Try each function in sequence, returning the first success

Try each function in sequence, returning the first success

## Usage

``` r
.try_fns(x, fns, x_arg, call)
```

## Arguments

- x:

  The value to test.

- fns:

  `(list)` The list of stabilizer or coercion functions to try.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The result of the first function that does not throw an error.
