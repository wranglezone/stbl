# Apply a spec and check that it agrees with the running result

Apply a spec and check that it agrees with the running result

## Usage

``` r
.check_consensus(result, fn, x, x_arg, call)
```

## Arguments

- result:

  The value obtained from the specs applied so far.

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

`fn`'s result, if it agrees with `result`; otherwise, throws an error.
