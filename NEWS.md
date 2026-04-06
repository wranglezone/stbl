# stbl (development version)

* New `pkg_inform()` signals classed messages with an opinionated class hierarchy, mirroring `pkg_abort()`. New `expect_pkg_message_classes()` tests that a message with the expected set of classes is thrown, and `expect_pkg_message_snapshot()` snapshot-tests the full message output in one step (#213).
* New `pkg_warn()` signals classed warnings with an opinionated class hierarchy, mirroring `pkg_abort()`. New `expect_pkg_warning_classes()` tests that a warning with the expected set of classes is thrown, and `expect_pkg_warning_snapshot()` snapshot-tests the full warning output in one step (#213).
* `are_lgl_ish()` and `to_lgl()` for character input now use a single-pass C implementation (`stbl_lgl_from_chr`), eliminating the duplicate `toupper()` call that was the main performance bottleneck. Benchmarks show >5x speedup for large character vectors (#218).

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
