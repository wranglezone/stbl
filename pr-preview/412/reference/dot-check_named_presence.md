# Check that an object is (or is not) named

Check that an object is (or is not) named

## Usage

``` r
.check_named_presence(x, named, x_arg, call)
```

## Arguments

- x:

  The object to check.

- named:

  `(logical(1))` Should `x` be named?

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
