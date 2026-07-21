# Snapshot-test a package message

A convenience wrapper around
[`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html)
and
[`expect_pkg_message_classes()`](https://stbl.wrangle.zone/dev/reference/expect_pkg_message_classes.md)
that captures both the message class hierarchy and the user-facing
message in a single snapshot.

## Usage

``` r
expect_pkg_message_snapshot(
  object,
  package,
  ...,
  transform = NULL,
  variant = NULL,
  env = caller_env()
)
```

## Arguments

- object:

  An expression that is expected to throw a message.

- package:

  `(length-1 character)` The name of the package to use in classes.

- ...:

  `(character)` Components of the class name, from least-specific to
  most.

- transform:

  (`function` or `NULL`) Optional function to scrub volatile output
  (e.g. temp paths) before snapshot comparison. Passed through to
  [`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html).

- variant:

  (`character(1)` or `NULL`) Optional snapshot variant name. Passed
  through to
  [`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html).

- env:

  (`environment`) The environment in which `object` should be evaluated.
  Assignments made inside `object` are visible to the caller after this
  function returns.
  [`expect_pkg_message_classes()`](https://stbl.wrangle.zone/dev/reference/expect_pkg_message_classes.md)
  is temporarily injected into `env` if it is not already findable, so
  this works even when this package is not attached.

## Value

The result of
[`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html),
invisibly.
