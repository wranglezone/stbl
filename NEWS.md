# stbl (development version)

## New features

* New condition functions: `pkg_abort()` throws errors with a standardized, opinionated collection of classes, and `expect_pkg_error_classes()` checks that an error with the expected set of classes is thrown (#136).

## Potential breaking changes

* Several conditions that formerly included a subclass of "stbl-error-must" no longer include that subclass. This only occurs when "stbl-error-must" was not the most specific subclass (i.e., when a more specific subclass was already included), and therefore should not impact most if any code (#136). 

## Other changes

* Revised the "Getting started with stbl" vignette to clarify what happens at each step (#139).

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
