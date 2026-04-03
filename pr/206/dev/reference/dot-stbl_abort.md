# Signal an error with standards applied

A wrapper around
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html) to
throw classed errors.

## Usage

``` r
.stbl_abort(
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
)
```

## Arguments

- message:

  (`character`) The message for the new error. Messages will be
  formatted with
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html).

- subclass:

  (`character`) Class(es) to assign to the error. Will be prefixed by
  "stbl-error-".

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

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
