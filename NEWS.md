# stbl (development version)

## Breaking changes

* `expect_pkg_error_snapshot()`, `expect_pkg_message_snapshot()`, and `expect_pkg_warning_snapshot()` now produce snapshots that mirror `testthat::expect_snapshot()`, showing the bare expression under `Code` and the condition class alongside its message. Existing snapshots must be re-accepted (#301).
* `stabilize_present()` is now named `assert_present()`, since it doesn't stabilize (coerce) its input; it only asserts that the input is not `NULL`. Calling `stabilize_present()` now throws a "deprecated"-classed error directing you to `assert_present()` (#299).

## New features

* Errors raised for element-wise failures now carry an integer `locations` element on the condition object, giving the positions in the input that failed the check. Handlers can read these positions via `cnd$locations` (#274).
* `stabilize_*()` and related helpers now document the error class hierarchy and function-specific failure subclasses in their `@returns` sections, making condition testing and handling easier (#308).

## Bug fixes

* `to_chr()`, `to_dbl()`, `to_fct()`, `to_int()`, and `to_lgl()` now throw an "incompatible type" error (with failing element locations) instead of a generic "can't coerce" error when a list contains elements that can't be converted (#273).

## New functions

* New `stabilize_any_of()` (and `stabilise_any_of()`) validates `x` by trying each unnamed stabilizer function in `...` in order, returning the first successful result. If all functions fail, an informative error combining the individual failure messages is thrown. New `to_any_of()` works analogously, accepting type prototypes (e.g. `integer()`, `character()`) in `...` and dispatching to [to()] (#215, #285).

# stbl 0.4.0

## Breaking changes

* `to_df()` and `to_lst()` now error if extra arguments are passed in `...`. Previously, these extra arguments were silently discarded (#200).
* `to_chr()` now converts named functions to a string representing their name instead of erroring. Package functions are returned as `"pkg::fn"` (e.g., `to_chr(mean)` returns `"base::mean"`). Anonymous functions still produce an informative error. This behavior extends to `to_chr_scalar()`, `stabilize_chr()`, and `stabilize_chr_scalar()` (#251).

## New functions

* New `pkg_inform()` and `pkg_warn()` signal classed messages and warnings, respectively, with an opinionated class hierarchy, mirroring `pkg_abort()`. New `expect_pkg_message_classes()` and `expect_pkg_warning_classes()` test that the expected classes are thrown, and `expect_pkg_message_snapshot()` and `expect_pkg_warning_snapshot()` snapshot-test the full output in one step (#213).
* New function `to()` coerces `x` to the type of its `.to` argument. `stbl_to()` is also registered as a C callable in a new public C API (#182).
* New `to_fn()`, `are_fn_ish()`, and `is_fn_ish()` add the `fn` type family to stbl. `to_fn()` coerces strings and symbols to functions. `is_fn_ish()` checks whether a single object can be safely coerced to a function. `are_fn_ish()` checks each element of a character vector for syntactic fn-ishness (bare name or `"pkg::fn"` form) (#250).

## Bug fixes

* `expect_pkg_error_snapshot()`, `expect_pkg_message_snapshot()`, and `expect_pkg_warning_snapshot()` now produce stable snapshots when run under `devtools::test_coverage_active_file()`. `specify_cls()` and related `specify_*()` functions now also produce stable function-body snapshots under coverage (#253).
* `expect_pkg_message_classes()` and `expect_pkg_warning_classes()` now support assignments inside `object` (e.g. `result <- fn_that_warns()`). `expect_pkg_message_snapshot()` and `expect_pkg_warning_snapshot()` inherit the same fix (#234).

## Other changes

* `are_*_ish()`, `to_*()`, `stabilize_dbl()`, and `stabilize_int()` are all significantly faster for large vectors, with benchmarks showing roughly 3–20× throughput improvements (#217, #218, #219, #220, #221, #226, #239).
* The `are_*_ish()`, `to_*()`, and range-check functions are now registered as C callables, as are the `*_to_chr` and `*_to_fct` families (`stbl_chr_to_fct()`, `stbl_dbl_to_chr()`, `stbl_dbl_are_chrish()`, `stbl_fct_to_chr()`, `stbl_fct_are_chrish()`, `stbl_int_to_chr()`, `stbl_int_are_chrish()`, `stbl_int_to_fct()`, `stbl_lgl_to_chr()`, and `stbl_lgl_are_chrish()`) (#235, #237, #241).
* `is_fct_ish()` now accepts a `max_levels` argument to limit the number of unique non-`NA` levels (#231).

# stbl 0.3.0

## Breaking changes

* `to_chr_scalar()`, `to_dbl_scalar()`, `to_fct_scalar()`, `to_int_scalar()`, `to_lgl_scalar()`, `stabilize_chr_scalar()`, `stabilize_dbl_scalar()`, `stabilize_fct_scalar()`, `stabilize_int_scalar()`, `stabilize_lgl_scalar()`, `specify_chr_scalar()`, `specify_dbl_scalar()`, `specify_fct_scalar()`, `specify_int_scalar()`, and `specify_lgl_scalar()` (and their synonyms) now default to `allow_null = FALSE` and `allow_zero_length = FALSE`. Pass `allow_null = TRUE` or `allow_zero_length = TRUE` to restore the previous behavior (#189, #197).

## Potential breaking changes

* Several conditions that formerly included a subclass of "stbl-error-must" no longer include that subclass. This only occurs when "stbl-error-must" was not the most specific subclass (i.e., when a more specific subclass was already included), and therefore should not impact most if any code (#136).

## New features

* New long-form and British-spelling synonym functions for all class functions. For example, `to_character()` is a synonym for `to_chr()`, `specify_logical()` for `specify_lgl()`, and `stabilise_*()` for all `stabilize_*()` functions (#164, #167).
* New `expect_pkg_error_classes()` checks that an error with the expected set of classes is thrown by `pkg_abort()`, and `expect_pkg_error_snapshot()` snapshot-tests the full error output in one step by combining `expect_snapshot()` with `expect_pkg_error_classes()` (#136, #188). New `pkg_abort()` throws errors with a standardized, opinionated collection of classes (#136).
* New specification functions: `specify_*()` creates a `"stbl_specified_fn"`, a call to the corresponding `stabilize_*()` function with arguments pre-filled. For example, `stabilize_email <- specify_chr(regex = "^[^@]+@[^@]+\\.[^@]+$")` creates a `stabilize_email()` function that validates email addresses (#147, #148, #149, #150, #151, #153, #161).
* New `stabilize_df()` and `specify_df()` validate data frame structure and contents (#142).
* New `stabilize_lst()` and `specify_lst()` validate list structure and contents and create pre-configured validators for nested validation (#110, #204).
* New `stabilize_present()` validates that a value is non-`NULL` without imposing any type constraints (#110).
* New `to_df()` (and synonym `to_data_frame()`) coerces compatible objects to a data frame, including named lists and named atomic vectors (e.g., `to_df(letters)`), with informative errors for incompatible inputs such as jagged lists (#142, #201, #203).
* New `to_lst()` (and synonym `to_list()`) coerces an object to a list, with conditional checks for `NULL` and functions (#157, #166).

## Other changes

* Revised the "Getting started with stbl" vignette to clarify what happens at each step (#139, #143, #144).
* Clarified error messages (#176, #177).

# stbl 0.2.0

## New features

* New predicate functions check if an object can be safely coerced to a specific type. The `is_*_ish()` family (`is_chr_ish()`, `is_dbl_ish()`, `is_fct_ish()`, `is_int_ish()`, and `is_lgl_ish()`) checks the entire object at once. The `are_*_ish()` family (`are_chr_ish()`, `are_dbl_ish()`, `are_fct_ish()`, `are_int_ish()`, and `are_lgl_ish()`) checks each element of a vector individually (#23, #93).
* New functions for working with doubles are available: `to_dbl()`, `to_dbl_scalar()`, `stabilize_dbl()`, and `stabilize_dbl_scalar()` (#23).
* `stabilize_chr()` now accepts patterns from `stringr::regex()`, `stringr::fixed()`, and `stringr::coll()` (#87), and can generate more informative error messages for regex failures via the new `regex_must_match()` and `regex_must_not_match()` helper functions (#52, #85, #86, #89).

## Minor improvements and fixes

* Error messages are now clearer and more standardized throughout the package (#95).
* `to_*()` functions now consistently flatten list-like inputs when no information would be lost in the process (#128).
* `to_fct()` now lists the allowed values in its error message when a value is not in the expected set, making it easier to debug (#67).
* `to_lgl()` now coerces character representations of numbers (e.g., "0" and "1") to `FALSE` and `TRUE` respectively (#30).

## Documentation

* The purpose of and vision for this package are now more clearly described in documentation (#56, #77).
* New `vignette("stbl")` provides an overview of the package and its functions (#42).

# stbl 0.1.1

* Update formatting in DESCRIPTION and examples.

# stbl 0.1.0

* Initial CRAN submission.
