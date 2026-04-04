# Snapshot-test a package error

A convenience wrapper around
[`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html)
and
[`expect_pkg_error_classes()`](https://stbl.wrangle.zone/reference/expect_pkg_error_classes.md)
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
  env = caller_env()
)
```

## Arguments

- object:

  An expression that is expected to throw an error.

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
  The actual evaluation will occur in a child of this environment, with
  [`expect_pkg_error_classes()`](https://stbl.wrangle.zone/reference/expect_pkg_error_classes.md)
  available even if this package is not attached.

## Value

The result of
[`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html),
invisibly.
