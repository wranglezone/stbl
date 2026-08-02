# Replace a stbl error with a custom message

Catches a `{stbl}` error with the specified `subclass` and replaces its
message with a new one. Use this to provide more context-specific error
messages when calling `{stbl}` functions inside your own package.

## Usage

``` r
replace_stbl_error(
  expr,
  subclass,
  message,
  call = caller_env(),
  message_env = call,
  additional_class = character()
)
```

## Arguments

- expr:

  An expression to evaluate.

- subclass:

  (`character`) The subclass(es) of the `{stbl}` error to catch.
  Combined with `"stbl-error-"` to form the class name to intercept. For
  example, `c("coerce", "character")` catches errors of class
  `stbl-error-coerce-character`, while `c("coerce")` catches any
  `stbl-error-coerce` error.

- message:

  (`character`) The replacement message. Formatted with
  [`cli::cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.html).

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- message_env:

  (`environment`) The execution environment to use to evaluate variables
  in error messages.

- additional_class:

  (`character`) Additional classes to prepend to the error class list.
  These are used exactly as-is — no `"stbl-error-"` prefix is added.
  Defaults to [`character()`](https://rdrr.io/r/base/character.html) (no
  additional classes).

## Value

The result of `expr`, or an error with the replacement message if a
matching `{stbl}` error is thrown.

## Details

The `subclass` argument mirrors the subclass hierarchy used when the
error was originally thrown. For example, an error with class
`stbl-error-coerce-character` is caught with
`subclass = c("coerce", "character")`. Any `coerce` error (regardless of
the target type) is caught with `subclass = c("coerce")`. Similarly,
`stbl-error-incompatible_values-integer` is caught with
`subclass = c("incompatible_values", "integer")`.

## Examples

``` r
my_fn <- function(x) {
  replace_stbl_error(
    to_chr(x),
    subclass = c("coerce", "character"),
    message = "{.arg x} must be a character string."
  )
}
try(my_fn(data.frame()))
#> Error in my_fn(data.frame()) : `x` must be a character string.

my_fn2 <- function(x) {
  replace_stbl_error(
    to_chr(x),
    subclass = c("coerce", "character"),
    message = "{.arg x} must be a character string.",
    additional_class = "mypkg-error-bad_chr"
  )
}
try(my_fn2(data.frame()))
#> Error in my_fn2(data.frame()) : `x` must be a character string.
```
