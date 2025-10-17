
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stbl

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/stbl)](https://CRAN.R-project.org/package=stbl)
[![Codecov test
coverage](https://codecov.io/gh/wranglezone/stbl/branch/main/graph/badge.svg)](https://app.codecov.io/gh/wranglezone/stbl?branch=main)
[![R-CMD-check](https://github.com/wranglezone/stbl/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/wranglezone/stbl/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

R is flexible about classes. Variables are not declared with explicit
classes, and arguments of the “wrong” class don’t cause errors until
they explicitly fail at some point in the call stack. It would be
helpful to keep that flexibility from a user standpoint, but to error
informatively and quickly if the inputs will not work for a computation.
The purpose of stbl is to allow programmers to specify what they want,
and to then see if what the user supplied can work for that purpose.

This approach aligns with [Postel’s
Law](https://en.wikipedia.org/wiki/Robustness_principle):

> “Be conservative in what you send. Be liberal in what you accept from
> others.”

stbl is liberal about what it accepts (by coercing when safe) and
conservative about what it returns (by ensuring that inputs have the
classes and other features that are expected).

## Installation

Install the released version of stbl from
[CRAN](https://cran.r-project.org/):

``` r
install.packages("stbl")
```

<div class="pkgdown-devel">

Install the development version of stbl from
[GitHub](https://github.com/):

``` r
# install.packages("pak")
pak::pak("wranglezone/stbl")
```

</div>

## Usage

The primary use-case for stbl is to stabilize function arguments. The
goal is to make sure arguments will work the way you expect them to
work, and to give meaningful error messages when they won’t.

For example, perhaps you would like to protect against the case where
data is not properly translated from character to integer when it’s
loaded by a user.

### Without stbl:

Without the argument-stabilizers provided in stbl, error messages can be
cryptic, and errors trigger when you might not want them to.

``` r
my_old_fun <- function(my_arg_name) {
  my_arg_name + 1
}
my_old_fun("1")
#> Error in my_arg_name + 1: non-numeric argument to binary operator
```

### With stbl:

stbl helps to ensure that arguments are what you expect them to be.

``` r
my_fun <- function(my_arg_name) {
  my_arg_name <- stbl::to_int(my_arg_name)
  my_arg_name + 1
}
my_fun("1")
#> [1] 2
```

Failures are reported with helpful messages.

``` r
my_fun("1.1")
#> Error in `my_fun()`:
#> ! `my_arg_name` <character> must be coercible to <integer>
#> ✖ Can't convert some values due to loss of precision.
#> • Locations: 1
```

The errors help locate issues within vectors.

``` r
my_fun(c("1", "2", "3.1", "4", "5.2"))
#> Error in `my_fun()`:
#> ! `my_arg_name` <character> must be coercible to <integer>
#> ✖ Can't convert some values due to loss of precision.
#> • Locations: 3 and 5
```

See `vignette("stbl")` to learn more about how to use stbl, and when to
“upgrade” from `to_*()` functions to `stabilize_*()` functions.

## Similar Packages

Other packages perform functions similar to stbl, but with different
approaches:

- **[{checkmate}](https://mllg.github.io/checkmate/) and related
  assertion packages:** stbl’s `to_*()` and `stabilize_*()` functions
  are similar to the `assert*ish()` functions from {checkmate} with
  `coerce = TRUE`. stbl is usually faster, and provided classed error
  messages to allow you to handle different failure modes differently.
- **[{vctrs}](https://vctrs.r-lib.org/):** {vctrs} provides strict,
  low-level tools for coercion and type consistency, especially useful
  in package internals and base-type enforcement. stbl is more tolerant
  and higher-level, optimized for use in functions that accept flexible
  user inputs (e.g. letting a version number 1.1 be passed in as numeric
  or character and handling both gracefully).

## Code of Conduct

Please note that the stbl project is released with a [Contributor Code
of Conduct](https://stbl.wrangle.zone/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
