# Create a specified character stabilizer function

`specify_chr()` creates a function that will call
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
with the provided arguments. `specify_chr_scalar()` creates a function
that will call
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
with the provided arguments. `specify_character()` is a synonym of
`specify_chr()`, and `specify_character_scalar()` is a synonym of
`specify_chr_scalar()`.

## Usage

``` r
specify_chr(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  regex = NULL
)

specify_chr_scalar(
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  regex = NULL
)

specify_character(
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  regex = NULL
)

specify_character_scalar(
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  regex = NULL
)
```

## Arguments

- allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

- allow_na:

  `(length-1 logical)` Are NA values ok?

- min_size:

  `(length-1 integer)` The minimum size of the object. Object size will
  be tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- max_size:

  `(length-1 integer)` The maximum size of the object. Object size will
  be tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- regex:

  `(character, list, or stringr_pattern)` One or more optional regular
  expressions to test against the values of `x`. This can be a character
  vector, a list of character vectors, or a pattern object from the
  {stringr} package (e.g., `stringr::fixed("a.b")`). The default error
  message for non-matching values will include the pattern itself (see
  [`regex_must_match()`](https://stbl.wrangle.zone/dev/reference/regex_must_match.md)).
  To provide a custom message, supply a named character vector where the
  value is the regex pattern and the name is the message that should be
  displayed. To check that a pattern is *not* matched, attach a `negate`
  attribute set to `TRUE`. If a complex regex pattern throws an error,
  try installing the stringi package.

- allow_zero_length:

  `(length-1 logical)` Are zero-length vectors acceptable?

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
or
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
with the provided arguments. The generated function will also accept
`...` for additional arguments to pass to
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
or
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other character functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)

Other specification functions:
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md)

## Examples

``` r
stabilize_email <- specify_chr(regex = "^[^@]+@[^@]+\\.[^@]+$")
stabilize_email("stbl@example.com")
#> [1] "stbl@example.com"
try(stabilize_email("not-an-email-address"))
#> Error in eval(expr, envir) : 
#>   `"not-an-email-address"` must match the regex pattern
#> "^[^@]+@[^@]+\\.[^@]+$"
#> ✖ "not-an-email-address" fails the check.
```
