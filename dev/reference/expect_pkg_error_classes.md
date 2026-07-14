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
#> <error/stbl-error-test_subclass>
#> Error:
#> ! This is a test error
#> ---
#> Backtrace:
#>      ▆
#>   1. └─pkgdown::deploy_to_branch(new_process = FALSE)
#>   2.   └─pkgdown::build_site_github_pages(pkg, ..., clean = clean)
#>   3.     └─pkgdown::build_site(...)
#>   4.       └─pkgdown:::build_site_local(...)
#>   5.         └─pkgdown::build_reference(...)
#>   6.           ├─pkgdown:::unwrap_purrr_error(...)
#>   7.           │ └─base::withCallingHandlers(...)
#>   8.           └─purrr::map(...)
#>   9.             └─purrr:::map_("list", .x, .f, ..., .progress = .progress)
#>  10.               ├─purrr:::with_indexed_errors(...)
#>  11.               │ └─base::withCallingHandlers(...)
#>  12.               ├─purrr:::call_with_cleanup(...)
#>  13.               └─pkgdown (local) .f(.x[[i]], ...)
#>  14.                 ├─base::withCallingHandlers(...)
#>  15.                 └─pkgdown:::data_reference_topic(...)
#>  16.                   └─pkgdown:::run_examples(...)
#>  17.                     └─pkgdown:::highlight_examples(code, topic, env = env)
#>  18.                       └─downlit::evaluate_and_highlight(...)
#>  19.                         └─evaluate::evaluate(code, child_env(env), new_device = TRUE, output_handler = output_handler)
#>  20.                           ├─base::withRestarts(...)
#>  21.                           │ └─base (local) withRestartList(expr, restarts)
#>  22.                           │   ├─base (local) withOneRestart(withRestartList(expr, restarts[-nr]), restarts[[nr]])
#>  23.                           │   │ └─base (local) doWithOneRestart(return(expr), restart)
#>  24.                           │   └─base (local) withRestartList(expr, restarts[-nr])
#>  25.                           │     └─base (local) withOneRestart(expr, restarts[[1L]])
#>  26.                           │       └─base (local) doWithOneRestart(return(expr), restart)
#>  27.                           ├─evaluate:::with_handlers(...)
#>  28.                           │ ├─base::eval(call)
#>  29.                           │ │ └─base::eval(call)
#>  30.                           │ └─base::withCallingHandlers(...)
#>  31.                           ├─base::withVisible(eval(expr, envir))
#>  32.                           └─base::eval(expr, envir)
#>  33.                             └─base::eval(expr, envir)
try(
  expect_pkg_error_classes(
    pkg_abort("stbl", "This is a test error", "test_subclass"),
    "stbl",
    "different_subclass"
  )
)
#> Error : Expected `e` to have class "stbl-error-different_subclass"/"stbl-error"/"stbl-condition"/"rlang_error"/"error"/"condition".
#> Actual class: "stbl-error-test_subclass"/"stbl-error"/"stbl-condition"/"rlang_error"/"error"/"condition".
```
