# Check that an object is named and every name satisfies a spec

Check that an object is named and every name satisfies a spec

## Usage

``` r
.check_names_spec(x, spec, x_arg, call)
```

## Arguments

- x:

  The object to check.

- spec:

  `(function)` A stabilizer or conversion function to apply to
  `names(x)`.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` invisibly (called for side effects).
