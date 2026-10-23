# Apply a spec to each element of x, collecting every failure

Apply a spec to each element of x, collecting every failure

## Usage

``` r
.map_each_safe(x, spec, x_arg, call)
```

## Arguments

- x:

  The object to stabilize.

- spec:

  A single stabilizer/coercion function applied to each element.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

A list with elements:

- `out`: per-element results (`NULL` at any failing location).

- `errors`: per-element error conditions (`NULL` at any successful
  location).
