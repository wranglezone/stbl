# Signal a warning with standards applied

A wrapper around
[`cli::cli_warn()`](https://cli.r-lib.org/reference/cli_abort.html) to
throw classed warnings, with an opinionated framework of warning
classes.

## Usage

``` r
pkg_warn(
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

  (`character`) The message for the new warning. Messages will be
  formatted with
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html).

- subclass:

  (`character`) Class(es) to assign to the warning. Will be prefixed by
  "{package}-warning-".

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
  [`cli::cli_warn()`](https://cli.r-lib.org/reference/cli_abort.html)
  and on to
  [`rlang::warn()`](https://rlang.r-lib.org/reference/abort.html).

## Examples

``` r
pkg_warn("stbl", "This is a test warning", "test_subclass")
#> Warning: This is a test warning
withCallingHandlers(
  pkg_warn("stbl", "This is a test warning", "test_subclass"),
  `stbl-warning` = function(w) {
    message("Caught a generic stbl warning.")
    invokeRestart("muffleWarning")
  }
)
#> Caught a generic stbl warning.
withCallingHandlers(
  pkg_warn("stbl", "This is a test warning", "test_subclass"),
  `stbl-warning-test_subclass` = function(w) {
    message("Caught a specific subclass of stbl warning.")
    invokeRestart("muffleWarning")
  }
)
#> Caught a specific subclass of stbl warning.
```
