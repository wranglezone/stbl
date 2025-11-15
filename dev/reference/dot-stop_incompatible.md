# Abort with an "incompatible type" message

Abort with an "incompatible type" message

## Usage

``` r
.stop_incompatible(
  x_class,
  to,
  failures,
  due_to,
  x_arg,
  call,
  parent = NULL,
  ...
)
```

## Arguments

- x_class:

  `(length-1 character)` The class name of `x` to use in error messages.
  Use this if you remove a special class from `x` before checking its
  coercion, but want the error message to match the original class.

- to:

  The target object for the coercion.

- failures:

  `(logical)` A logical vector indicating which elements failed.

- due_to:

  `(length-1 character)` A string describing the reason for the failure.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- parent:

  A parent condition, as you might create during a
  [`rlang::try_fetch()`](https://rlang.r-lib.org/reference/try_fetch.html).
  See [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html)
  for additional information.

- ...:

  Additional parameters passed to
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  and on to
  [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html).

## Value

This function is called for its side effect of throwing an error and
does not return a value.
