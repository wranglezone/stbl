# Replace a stbl error with a custom message

Catches a `stbl` error with the specified `subclass` and replaces its
message with a new one. Use this to provide more context-specific error
messages when calling `stbl` functions inside your own functions. See
the documentation of each `stabilize_*()` or `to_*()` function for the
types of errors it throws.

## Usage

``` r
replace_stbl_error(
  expr,
  subclass,
  message,
  additional_class = character(),
  message_env = caller_env()
)
```

## Arguments

- expr:

  An expression to evaluate.

- subclass:

  (`character`) The subclass(es) of the `stbl` error to ignore. Combined
  with `"stbl-error-"` to form the class name to intercept. For example,
  `c("coerce", "character")` silences errors of class
  `stbl-error-coerce-character`
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)),
  while `c("coerce")` silences any `stbl-error-coerce` error.

- message:

  (`character`) The replacement error message. Formatted with
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html).

- additional_class:

  (`character`) Additional classes to prepend to the error class list.
  Useful for the `class` argument of
  [`testthat::expect_error()`](https://testthat.r-lib.org/reference/expect_error.html).

- message_env:

  (`environment`) The execution environment to use to evaluate variables
  in error messages.

## Value

The result of `expr`, or an error with the replacement message if a
matching `{stbl}` error is thrown.

## Examples

``` r
my_fn <- function(x) {
  x <- to_chr(x) |>
    replace_stbl_error(
      subclass = c("coerce", "character"),
      message = "{.arg x} must be a character vector of widgets"
    )
}
try(my_fn(data.frame()))
#> Error in my_fn(data.frame()) : 
#>   `x` must be a character vector of widgets

# Specify a class to check for expected errors with testthat::expect_error()
my_fn2 <- function(x) {
  x <- to_chr(x) |>
    replace_stbl_error(
      subclass = c("coerce", "character"),
      message = "{.arg x} must be a character vector of widgets",
      additional_class = "mypkg-error-bad_widget"
    )
}
try(my_fn2(data.frame()))
#> Error in my_fn2(data.frame()) : 
#>   `x` must be a character vector of widgets
```
