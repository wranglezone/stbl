# Apply a single spec to x, stopping if it errors

Apply a single spec to x, stopping if it errors

## Usage

``` r
.apply_spec_or_stop(fn, x, x_arg, call)
```

## Arguments

- fn:

  A stabilizer or coercion function to apply to `x`.

- x:

  The value to test.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The result of applying `fn` to `x`.
