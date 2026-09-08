# Try every item, requiring exactly one to succeed

Try every item, requiring exactly one to succeed

## Usage

``` r
.try_exactly_one(items, run_one, labels, x_arg, call)
```

## Arguments

- items:

  `(list)` The specifications to try (functions or prototypes).

- run_one:

  `(function)` A function taking a single item from `items` and
  returning its result for `x`, throwing an error on failure.

- labels:

  `(character)` A label for each item in `items`, used to identify
  matched specifications in the "more than one" error message.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The result of the single item that does not throw an error.
