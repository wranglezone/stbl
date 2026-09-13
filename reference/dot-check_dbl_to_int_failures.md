# Check for double to integer coercion failures

Check for double to integer coercion failures

## Usage

``` r
.check_dbl_to_int_failures(x, res, x_class, x_arg, call)
```

## Arguments

- x:

  The object to stabilize.

- res:

  A list returned by `stbl_dbl_to_int`, with elements `result` and
  `bad_precision`.

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

## Value

`NULL` invisibly (called for side effects).
