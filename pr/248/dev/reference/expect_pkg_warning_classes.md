# Test package warning classes

When you use
[`pkg_warn()`](https://stbl.wrangle.zone/dev/reference/pkg_warn.md) to
signal warnings, you can use this function to test that those warnings
are generated as expected.

## Usage

``` r
expect_pkg_warning_classes(object, package, ...)
```

## Arguments

- object:

  An expression that is expected to throw a warning.

- package:

  `(length-1 character)` The name of the package to use in classes.

- ...:

  `(character)` Components of the class name, from least-specific to
  most.

## Value

The classes of the warning invisibly on success or the warning on
failure. Unlike most testthat expectations, this expectation cannot be
usefully chained.

## Examples

``` r
expect_pkg_warning_classes(
  pkg_warn("stbl", "This is a test warning", "test_subclass"),
  "stbl",
  "test_subclass"
)
#> <warning/stbl-warning-test_subclass>
#> Warning:
#> This is a test warning
try(
  expect_pkg_warning_classes(
    pkg_warn("stbl", "This is a test warning", "test_subclass"),
    "stbl",
    "different_subclass"
  )
)
#> Error : Expected `w` to have class "stbl-warning-different_subclass"/"stbl-warning"/"stbl-condition"/"rlang_warning"/"warning"/"condition".
#> Actual class: "stbl-warning-test_subclass"/"stbl-warning"/"stbl-condition"/"rlang_warning"/"warning"/"condition".
```
