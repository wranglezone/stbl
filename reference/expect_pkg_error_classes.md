# Test package error classes

When you use
[`pkg_abort()`](https://stbl.wrangle.zone/reference/pkg_abort.md) to
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

  (`character(1)`) The name of the package to use in classes.

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
#>   1. ├─base::tryCatch(...)
#>   2. │ └─base (local) tryCatchList(expr, classes, parentenv, handlers)
#>   3. │   ├─base (local) tryCatchOne(...)
#>   4. │   │ └─base (local) doTryCatch(return(expr), name, parentenv, handler)
#>   5. │   └─base (local) tryCatchList(expr, names[-nh], parentenv, handlers[-nh])
#>   6. │     └─base (local) tryCatchOne(expr, names, parentenv, handlers[[1L]])
#>   7. │       └─base (local) doTryCatch(return(expr), name, parentenv, handler)
#>   8. ├─base::withCallingHandlers(...)
#>   9. ├─base::saveRDS(...)
#>  10. ├─base::do.call(...)
#>  11. ├─base (local) `<fn>`(...)
#>  12. └─global `<fn>`(...)
#>  13.   └─pkgdown::build_site(...)
#>  14.     └─pkgdown:::build_site_local(...)
#>  15.       └─pkgdown::build_reference(...)
#>  16.         ├─pkgdown:::unwrap_purrr_error(...)
#>  17.         │ └─base::withCallingHandlers(...)
#>  18.         └─purrr::map(...)
#>  19.           └─purrr:::map_("list", .x, .f, ..., .progress = .progress)
#>  20.             ├─purrr:::with_indexed_errors(...)
#>  21.             │ └─base::withCallingHandlers(...)
#>  22.             ├─purrr:::call_with_cleanup(...)
#>  23.             └─pkgdown (local) .f(.x[[i]], ...)
#>  24.               ├─base::withCallingHandlers(...)
#>  25.               └─pkgdown:::data_reference_topic(...)
#>  26.                 └─pkgdown:::run_examples(...)
#>  27.                   └─pkgdown:::highlight_examples(code, topic, env = env)
#>  28.                     └─downlit::evaluate_and_highlight(...)
#>  29.                       └─evaluate::evaluate(code, child_env(env), new_device = TRUE, output_handler = output_handler)
#>  30.                         ├─base::withRestarts(...)
#>  31.                         │ └─base (local) withRestartList(expr, restarts)
#>  32.                         │   ├─base (local) withOneRestart(withRestartList(expr, restarts[-nr]), restarts[[nr]])
#>  33.                         │   │ └─base (local) doWithOneRestart(return(expr), restart)
#>  34.                         │   └─base (local) withRestartList(expr, restarts[-nr])
#>  35.                         │     └─base (local) withOneRestart(expr, restarts[[1L]])
#>  36.                         │       └─base (local) doWithOneRestart(return(expr), restart)
#>  37.                         ├─evaluate:::with_handlers(...)
#>  38.                         │ ├─base::eval(call)
#>  39.                         │ │ └─base::eval(call)
#>  40.                         │ └─base::withCallingHandlers(...)
#>  41.                         ├─base::withVisible(eval(expr, envir))
#>  42.                         └─base::eval(expr, envir)
#>  43.                           └─base::eval(expr, envir)
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
