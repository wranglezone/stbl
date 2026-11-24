# Apply a spec to each element of x, failing on the first error

Apply a spec to each element of x, failing on the first error

## Usage

``` r
.map_each_fast(x, spec, x_arg, call, to_arg = NULL, x_class = NULL)
```

## Arguments

- x:

  The object to stabilize.

- spec:

  A single stabilizer/conversion function applied to each element.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its conversion, but want the error message to
  match the original class.

## Value

A list of per-element results, the same length as `x`.
