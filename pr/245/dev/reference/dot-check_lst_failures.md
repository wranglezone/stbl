# Check list coercion failures and error if any element could not be converted

Check list coercion failures and error if any element could not be
converted

## Usage

``` r
.check_lst_failures(valid, to_class, x_class, x_arg, call)
```

## Arguments

- valid:

  `(logical)` The `valid` vector returned by a `stbl_lst_to_*` C
  routine.

- to_class:

  `(length-1 character)` The name of the class to coerce to.

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
