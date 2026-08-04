# Coerce to character with additional checks

Compared to
[`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
`stabilize_chr()` checks more details, but is slower. `stabilise_chr()`,
`stabilize_character()`, and `stabilise_character()` are synonyms of
`stabilize_chr()`.

## Usage

``` r
stabilize_chr(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_characters = NULL,
  max_characters = NULL,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_character(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_characters = NULL,
  max_characters = NULL,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_chr(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_characters = NULL,
  max_characters = NULL,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_character(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  unique = FALSE,
  min_characters = NULL,
  max_characters = NULL,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The argument to stabilize.

- ...:

  Arguments passed to methods.

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- allow_na:

  (`logical(1)`) Are NA values ok?

- min_size:

  (`integer(1)`) The minimum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- max_size:

  (`integer(1)`) The maximum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- unique:

  (`logical(1)`) Should all elements in `x` be distinct?

- min_characters:

  (`integer(1)`) Minimum number of characters allowed in each element.

- max_characters:

  (`integer(1)`) Maximum number of characters allowed in each element.

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

- x_arg:

  (`character(1)`) The name of the argument being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  (`character(1)`) The class name of the argument being stabilized to
  use in error messages. Use this if you remove a special class from the
  object before checking its coercion, but want the error message to
  match the original class.

## Value

The input as a character vector, or an error condition with classes
`<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
`<condition>`, and a specific class by failure mode:

- `<stbl-error-coerce-character>` when `x` cannot be coerced to
  character.

- `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.

- `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.

- `<stbl-error-size_too_small>` when the vector is shorter than
  `min_size`.

- `<stbl-error-size_too_large>` when the vector is longer than
  `max_size`.

- `<stbl-error-duplicate_elements>` when `unique = TRUE` and duplicates
  are present.

- `<stbl-error-n_characters-too_few>` when elements have fewer
  characters than `min_characters`.

- `<stbl-error-n_characters-too_many>` when elements have more
  characters than `max_characters`.

- `<stbl-error-regex_mismatch>` when `regex` checks fail.

## See also

Other character functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr_scalar.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
[`to_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/to_chr_scalar.md)

Other stabilization functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md),
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr_scalar.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl_scalar.md),
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct_scalar.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md),
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
[`to_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/to_chr_scalar.md),
[`to_dbl()`](https://stbl.wrangle.zone/dev/reference/to_dbl.md),
[`to_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dbl_scalar.md),
[`to_fct()`](https://stbl.wrangle.zone/dev/reference/to_fct.md),
[`to_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/to_fct_scalar.md),
[`to_int()`](https://stbl.wrangle.zone/dev/reference/to_int.md),
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/to_int_scalar.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md)

## Examples

``` r
stabilize_chr(letters)
#>  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"
#> [20] "t" "u" "v" "w" "x" "y" "z"
stabilize_chr(1:10)
#>  [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10"
stabilize_chr(NULL)
#> NULL
try(stabilize_chr(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
try(stabilize_chr(c("a", NA), allow_na = FALSE))
#> Error in eval(expr, envir) : 
#>   `c("a", NA)` must not contain NA values.
#> • NA locations: 2
try(stabilize_chr(letters, min_size = 50))
#> Error in eval(expr, envir) : `letters` must have size >= 50.
#> ✖ 26 is too small.
try(stabilize_chr(letters, max_size = 20))
#> Error in eval(expr, envir) : `letters` must have size <= 20.
#> ✖ 26 is too big.
try(stabilize_chr(c("hi", "hey"), min_characters = 3))
#> Error in eval(expr, envir) : 
#>   Each element of `c("hi", "hey")` must have >= 3 characters.
#> ℹ Some elements have too few characters.
#> ✖ Location: 1
#> ✖ Value: hi
try(stabilize_chr(c("hi", "hey"), max_characters = 2))
#> Error in eval(expr, envir) : 
#>   Each element of `c("hi", "hey")` must have <= 2 characters.
#> ℹ Some elements have too many characters.
#> ✖ Location: 2
#> ✖ Value: hey
try(stabilize_chr(c("hide", "find", "find", "hide"), regex = "hide"))
#> Error in eval(expr, envir) : 
#>   `c("hide", "find", "find", "hide")` must match the regex pattern "hide"
#> ✖ Some values fail the check.
#> ✖ Locations: 2 and 3
#> ✖ Values: find and find
```
