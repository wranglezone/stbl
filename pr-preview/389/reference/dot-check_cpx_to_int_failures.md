# Check for complex to integer conversion failures

Check for complex to integer conversion failures

## Usage

``` r
.check_cpx_to_int_failures(x, res, x_class, x_arg, call, to_arg = NULL)
```

## Arguments

- x:

  The object to stabilize.

- res:

  A list returned by `stbl_cpx_to_int`, with elements `result`,
  `non_number`, and `bad_precision`.

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its conversion, but want the error message to
  match the original class.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- to_arg:

  (`character(1)` or `NULL`) The name of the object that `x` is being
  converted to match, for use in error messages. When `NULL`, error
  messages describe only `x`. When supplied, conversion failure messages
  name both `x_arg` and `to_arg`.

## Value

`NULL` invisibly (called for side effects).
