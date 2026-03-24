# Signal an error with standards applied

A wrapper around
[`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html) to
throw classed errors, with an opinionated framework of error classes.

## Usage

``` r
pkg_abort(
  package,
  message,
  subclass,
  call = caller_env(),
  message_env = call,
  parent = NULL,
  ...
)
```

## Arguments

- package:

  `(length-1 character)` The name of the package to use in classes.

- message:

  (`character`) The message for the new error. Messages will be
  formatted with
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html).

- subclass:

  (`character`) Class(es) to assign to the error. Will be prefixed by
  "{package}-error-".

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

## Examples

``` r
try(pkg_abort("stbl", "This is a test error", "test_subclass"))
#> Error in eval(expr, envir) : This is a test error
tryCatch(
  pkg_abort("stbl", "This is a test error", "test_subclass"),
  `stbl-error` = function(e) {
    "Caught a generic stbl error."
  }
)
#> [1] "Caught a generic stbl error."
tryCatch(
  pkg_abort("stbl", "This is a test error", "test_subclass"),
  `stbl-error-test_subclass` = function(e) {
    "Caught a specific subclass of stbl error."
  }
)
#> [1] "Caught a specific subclass of stbl error."
```
