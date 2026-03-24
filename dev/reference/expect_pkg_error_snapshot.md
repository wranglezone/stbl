# Snapshot-test a package error

A convenience wrapper around
[`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html)
and
[`expect_pkg_error_classes()`](https://stbl.wrangle.zone/dev/reference/expect_pkg_error_classes.md)
that captures both the error class hierarchy and the user-facing message
in a single snapshot.

## Usage

``` r
expect_pkg_error_snapshot(
  object,
  package,
  ...,
  transform = NULL,
  variant = NULL,
  call = caller_env()
)
```

## Arguments

- object:

  (`expression`) The expression expected to throw a package error.

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

- call:

  (`environment`) The call environment used as the evaluation
  environment for
  [`rlang::inject()`](https://rlang.r-lib.org/reference/inject.html).

## Value

The result of
[`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html),
invisibly.
