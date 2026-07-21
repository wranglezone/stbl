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

The warning condition invisibly. Assignments made inside `object` (e.g.
`result <- fn_that_warns()`) are visible to the caller after this
function returns. Unlike most testthat expectations, this expectation
cannot be usefully chained.

## Examples

``` r
expect_pkg_warning_classes(
  pkg_warn("stbl", "This is a test warning", "test_subclass"),
  "stbl",
  "test_subclass"
)
try(
  expect_pkg_warning_classes(
    pkg_warn("stbl", "This is a test warning", "test_subclass"),
    "stbl",
    "different_subclass"
  )
)
#> Error : Expected `captured` to have class "stbl-warning-different_subclass"/"stbl-warning"/"stbl-condition"/"rlang_warning"/"warning"/"condition".
#> Actual class: "stbl-warning-test_subclass"/"stbl-warning"/"stbl-condition"/"rlang_warning"/"warning"/"condition".
```
