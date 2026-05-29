# Check for character to integer coercion failures

Check for character to integer coercion failures

## Usage

``` r
.check_chr_to_int_failures(res, x_class, x_arg, call)
```

## Arguments

- res:

  A list returned by `ffi_chr_to_int`, with elements `result`,
  `non_number`, and `bad_precision`.

- x_class:

  `(length-1 character)` The class name of the argument being stabilized
  to use in error messages. Use this if you remove a special class from
  the object before checking its coercion, but want the error message to
  match the original class.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` invisibly (called for side effects).
