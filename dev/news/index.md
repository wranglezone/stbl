# Changelog

## stbl (development version)

### New features

- New
  [`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md)
  and
  [`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md)
  to validate list structure and contents and create pre-configured list
  validators for nested validation
  ([\#110](https://github.com/wranglezone/stbl/issues/110)).
- New
  [`stabilize_present()`](https://stbl.wrangle.zone/dev/reference/stabilize_present.md)
  validates that a value is non-`NULL` without imposing any type
  constraints ([\#110](https://github.com/wranglezone/stbl/issues/110)).
- New
  [`expect_pkg_error_snapshot()`](https://stbl.wrangle.zone/dev/reference/expect_pkg_error_snapshot.md)
  function to snapshot-test the full error output of
  [`pkg_abort()`](https://stbl.wrangle.zone/dev/reference/pkg_abort.md)-style
  errors in one step, combining `expect_snapshot()` with
  [`expect_pkg_error_classes()`](https://stbl.wrangle.zone/dev/reference/expect_pkg_error_classes.md)
  ([\#188](https://github.com/wranglezone/stbl/issues/188)).
- New condition functions:
  [`pkg_abort()`](https://stbl.wrangle.zone/dev/reference/pkg_abort.md)
  throws errors with a standardized, opinionated collection of classes,
  and
  [`expect_pkg_error_classes()`](https://stbl.wrangle.zone/dev/reference/expect_pkg_error_classes.md)
  checks that an error with the expected set of classes is thrown
  ([\#136](https://github.com/wranglezone/stbl/issues/136)).
- New specification functions: `specify_*()` creates a “stbl-specified
  function” (class `"stbl_specified_fn"`), a call to the corresponding
  `stabilize_*()` function with arguments pre-filled. For example,
  `stabilize_email <- specify_chr(regex = "^[^@]+@[^@]+\\.[^@]+$")`
  creates a `stabilize_email()` function that calls
  [`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
  with `regex = "^[^@]+@[^@]+\\.[^@]+$"`, which could then be used to
  stabilize email addresses
  ([\#147](https://github.com/wranglezone/stbl/issues/147),
  [\#148](https://github.com/wranglezone/stbl/issues/148),
  [\#149](https://github.com/wranglezone/stbl/issues/149),
  [\#150](https://github.com/wranglezone/stbl/issues/150),
  [\#151](https://github.com/wranglezone/stbl/issues/151)).
- New function
  [`to_lst()`](https://stbl.wrangle.zone/dev/reference/to_lst.md) (and
  synonym
  [`to_list()`](https://stbl.wrangle.zone/dev/reference/to_lst.md)) to
  coerce an object to a list, with conditional checks for `NULL` and
  functions ([\#157](https://github.com/wranglezone/stbl/issues/157),
  [\#166](https://github.com/wranglezone/stbl/issues/166)).
- New synonym functions for all class functions. For example
  [`to_character()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
  is now a synonym for
  [`to_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  and
  [`specify_logical()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md)
  is a synonym for
  [`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md)
  ([\#164](https://github.com/wranglezone/stbl/issues/164)). In
  addition, `stabilise_*()` synonyms have been added for all
  `stabilize_*()` functions
  ([\#167](https://github.com/wranglezone/stbl/issues/167)).

### Breaking changes

- [`to_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  [`to_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
  [`to_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
  [`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
  [`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md),
  [`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  [`stabilize_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
  [`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
  [`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
  and
  [`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
  (and their synonyms) now default to `allow_null = FALSE` and
  `allow_zero_length = FALSE`. Pass `allow_null = TRUE` or
  `allow_zero_length = TRUE` to restore the previous behavior
  ([\#189](https://github.com/wranglezone/stbl/issues/189)).

### Potential breaking changes

- Several conditions that formerly included a subclass of
  “stbl-error-must” no longer include that subclass. This only occurs
  when “stbl-error-must” was not the most specific subclass (i.e., when
  a more specific subclass was already included), and therefore should
  not impact most if any code
  ([\#136](https://github.com/wranglezone/stbl/issues/136)).

### Other changes

- Revised the “Getting started with stbl” vignette to clarify what
  happens at each step
  ([\#139](https://github.com/wranglezone/stbl/issues/139),
  [\#143](https://github.com/wranglezone/stbl/issues/143),
  [\#144](https://github.com/wranglezone/stbl/issues/144)).
- Clarified error messages
  ([\#176](https://github.com/wranglezone/stbl/issues/176),
  [\#177](https://github.com/wranglezone/stbl/issues/177)).

## stbl 0.2.0

CRAN release: 2025-09-16

### New features

- New predicate functions check if an object can be safely coerced to a
  specific type. The `is_*_ish()` family
  ([`is_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
  [`is_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
  [`is_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
  [`is_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
  and
  [`is_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md))
  checks the entire object at once. The `are_*_ish()` family
  ([`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
  [`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
  [`are_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
  [`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
  and
  [`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md))
  checks each element of a vector individually
  ([\#23](https://github.com/wranglezone/stbl/issues/23),
  [\#93](https://github.com/wranglezone/stbl/issues/93)).
- New functions for working with doubles are available:
  [`to_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
  [`to_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
  [`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
  and
  [`stabilize_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md)
  ([\#23](https://github.com/wranglezone/stbl/issues/23)).
- [`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
  now accepts patterns from
  [`stringr::regex()`](https://stringr.tidyverse.org/reference/modifiers.html),
  [`stringr::fixed()`](https://stringr.tidyverse.org/reference/modifiers.html),
  and
  [`stringr::coll()`](https://stringr.tidyverse.org/reference/modifiers.html)
  ([\#87](https://github.com/wranglezone/stbl/issues/87)), and can
  generate more informative error messages for regex failures via the
  new
  [`regex_must_match()`](https://stbl.wrangle.zone/dev/reference/regex_must_match.md)
  and
  [`regex_must_not_match()`](https://stbl.wrangle.zone/dev/reference/regex_must_match.md)
  helper functions
  ([\#52](https://github.com/wranglezone/stbl/issues/52),
  [\#85](https://github.com/wranglezone/stbl/issues/85),
  [\#86](https://github.com/wranglezone/stbl/issues/86),
  [\#89](https://github.com/wranglezone/stbl/issues/89)).

### Minor improvements and fixes

- Error messages are now clearer and more standardized throughout the
  package ([\#95](https://github.com/wranglezone/stbl/issues/95)).
- `to_*()` functions now consistently flatten list-like inputs when no
  information would be lost in the process
  ([\#128](https://github.com/wranglezone/stbl/issues/128)).
- [`to_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md)
  now lists the allowed values in its error message when a value is not
  in the expected set, making it easier to debug
  ([\#67](https://github.com/wranglezone/stbl/issues/67)).
- [`to_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)
  now coerces character representations of numbers (e.g., “0” and “1”)
  to `FALSE` and `TRUE` respectively
  ([\#30](https://github.com/wranglezone/stbl/issues/30)).

### Documentation

- The purpose of and vision for this package are now more clearly
  described in documentation
  ([\#56](https://github.com/wranglezone/stbl/issues/56),
  [\#77](https://github.com/wranglezone/stbl/issues/77)).
- New
  [`vignette("stbl")`](https://stbl.wrangle.zone/dev/articles/stbl.md)
  provides an overview of the package and its functions
  ([\#42](https://github.com/wranglezone/stbl/issues/42)).

## stbl 0.1.1

CRAN release: 2024-05-23

- Update formatting in DESCRIPTION and examples.

## stbl 0.1.0

- Initial CRAN submission.
