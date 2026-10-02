# Find which elements of x match a spec applied independently to each element

Find which elements of x match a spec applied independently to each
element

## Usage

``` r
.find_spec_matches(x, fn, x_arg, call)
```

## Arguments

- x:

  The object to test.

- fn:

  A stabilizer or coercion function, applied to each element of `x`
  independently.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

An integer vector of positions in `x` that match `fn`.
