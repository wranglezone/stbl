# Test package error classes

When you use
[`pkg_abort()`](https://stbl.wrangle.zone/dev/reference/pkg_abort.md) to
signal errors, you can use this function to test that those errors are
generated as expected.

## Usage

``` r
expect_pkg_error_classes(object, package, ...)
```

## Arguments

- object:

  An expression that is expected to throw an error.

- package:

  `(length-1 character)` The name of the package to use in classes.

- ...:

  `(character)` Components of the class name, from least-specific to
  most.

## Value

The classes of the error invisibly on success or the error on failure.
Unlike most testthat expectations, this expectation cannot be usefully
chained.

## Examples

``` r
expect_pkg_error_classes(
  pkg_abort("stbl", "This is a test error", "test_subclass"),
  "stbl",
  "test_subclass"
)
try(
  expect_pkg_error_classes(
    pkg_abort("stbl", "This is a test error", "test_subclass"),
    "stbl",
    "different_subclass"
  )
)
#> Error : `object_error` has class 'stbl-error-test_subclass'/'stbl-error'/'stbl-condition'/'rlang_error'/'error'/'condition', not 'stbl-error-different_subclass'/'stbl-error'/'stbl-condition'/'rlang_error'/'error'/'condition'.
```
