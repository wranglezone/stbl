# Abort with a standardized "must" message

Abort with a standardized "must" message

## Usage

``` r
.stop_must(
  msg,
  x_arg,
  call,
  additional_msg = NULL,
  subclass = "must",
  message_env = call,
  parent = NULL,
  ...
)
```

## Arguments

- msg:

  `(character)` The core error message describing the requirement.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- additional_msg:

  `(character)` Optional, additional cli-formatted messages.

- subclass:

  (`character`) Class(es) to assign to the error. Will be prefixed by
  "stbl-error-".

- message_env:

  (`environment`) The execution environment to use to evaluate variables
  in error messages.

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
