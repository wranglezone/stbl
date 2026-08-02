# Coerce to length-1 character with additional checks

Checks whether a vector can be coerced to a length-1 character vector.
`stabilize_chr_scalar()` is optimized to check for length-1 character
vectors (compared to
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)
with `max_size = 1`). `stabilise_chr_scalar`,
`stabilize_character_scalar()`, and `stabilise_character_scalar` are
synonyms of `stabilize_chr_scalar()`.

## Usage

``` r
stabilize_chr_scalar(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_character_scalar(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_chr_scalar(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_character_scalar(
  x,
  ...,
  allow_null = FALSE,
  allow_zero_length = FALSE,
  allow_na = TRUE,
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

  `(length-1 logical)` Is NULL an acceptable value?

- allow_zero_length:

  `(length-1 logical)` Are zero-length vectors acceptable?

- allow_na:

  `(length-1 logical)` Are NA values ok?

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

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  `(length-1 character)` The class name of the argument being stabilized
  to use in error messages. Use this if you remove a special class from
  the object before checking its coercion, but want the error message to
  match the original class.

## Value

The input as a length-1 character vector, or an error condition with
classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
`<condition>`, and a specific class by failure mode:

- `<stbl-error-coerce-character>` when `x` cannot be coerced to
  character.

- `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.

- `<stbl-error-bad_empty>` for empty vectors when
  `allow_zero_length = FALSE`.

- `<stbl-error-non_scalar>` for non-scalar vectors.

- `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.

- `<stbl-error-regex_mismatch>` when `regex` checks fail.

## See also

Other character functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
[`to_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/to_chr_scalar.md)

Other stabilization functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md),
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
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
stabilize_chr_scalar(TRUE)
#> [1] "TRUE"
try(stabilize_chr_scalar(c(TRUE, FALSE, TRUE)))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, FALSE, TRUE)` must be a single <character>.
#> ✖ `c(TRUE, FALSE, TRUE)` has 3 values.
try(stabilize_chr_scalar(NULL))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
stabilize_chr_scalar(NULL, allow_null = TRUE)
#> NULL
```
