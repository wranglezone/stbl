# Snapshot-test a package condition

Snapshot-test a package condition

## Usage

``` r
.expect_pkg_condition_snapshot(
  obj_expr,
  package,
  class_components,
  expect_fn_name,
  expect_fn,
  check_installed_msg,
  transform,
  variant,
  env
)
```

## Arguments

- obj_expr:

  An unevaluated expression (from
  [`rlang::enexpr()`](https://rlang.r-lib.org/reference/defusing-advanced.html)).

- package:

  `(length-1 character)` The name of the package to use in classes.

- class_components:

  (`list`) Passed as `...` to `expect_fn`.

- expect_fn_name:

  (`character(1)`) Name of the class-checking expectation to look up or
  inject into `env`.

- expect_fn:

  (`function`) The function to inject if not already findable.

- check_installed_msg:

  (`character(1)`) The `"to ..."` string passed to
  [`rlang::check_installed()`](https://rlang.r-lib.org/reference/is_installed.html).

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
  [`expect_pkg_warning_classes()`](https://stbl.wrangle.zone/dev/reference/expect_pkg_warning_classes.md)
  is temporarily injected into `env` if it is not already findable, so
  this works even when this package is not attached.

## Value

The result of
[`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html),
invisibly.
