# Ensure a character argument meets expectations

`to_chr()` checks whether an argument can be coerced to character
without losing information, returning it silently if so. Otherwise an
informative error message is signaled. `to_character` is a synonym of
`to_chr()`.

`stabilize_chr()` can check more details about the argument, but is
slower than `to_chr()`. `stabilise_chr()`, `stabilize_character()`, and
`stabilise_character()` are synonyms of `stabilize_chr()`.

`stabilize_chr_scalar()` and `to_chr_scalar()` are optimized to check
for length-1 character vectors. `stabilise_chr_scalar`,
`stabilize_character_scalar()`, and `stabilise_character_scalar` are
synonyms of `stabilize_chr_scalar()`, and `to_character_scalar()` is a
synonym of `to_chr_scalar()`.

## Usage

``` r
stabilize_chr(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
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
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_chr_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_character_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_chr_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_character_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  regex = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_chr(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_character(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_chr(x, ..., allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())

to_chr_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_character_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
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

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  `(length-1 character)` The class name of `x` to use in error messages.
  Use this if you remove a special class from `x` before checking its
  coercion, but want the error message to match the original class.

- allow_zero_length:

  `(length-1 logical)` Are zero-length vectors acceptable?

## Value

The argument as a character vector.

## Details

These functions have two important differences from
[`base::as.character()`](https://rdrr.io/r/base/character.html):

- `list`s and `data.frame`s are *not* coerced to character. In base R,
  such objects are coerced to character representations of their
  elements. For example, `as.character(list(1:3))` returns "1:10". In
  the unlikely event that this is the expected behavior, use
  [`as.character()`](https://rdrr.io/r/base/character.html) instead.

- `NULL` values can be rejected as part of the call to this function
  (with `allow_null = FALSE`).

## See also

Other character functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md)

Other stabilization functions:
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)

## Examples

``` r
to_chr("a")
#> [1] "a"
to_chr(letters)
#>  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"
#> [20] "t" "u" "v" "w" "x" "y" "z"
to_chr(1:10)
#>  [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10"
to_chr(1 + 0i)
#> [1] "1+0i"
to_chr(NULL)
#> NULL
try(to_chr(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.

to_chr_scalar("a")
#> [1] "a"
try(to_chr_scalar(letters))
#> Error in eval(expr, envir) : 
#>   `letters` must be a single <character>.
#> ✖ `letters` has 26 values.

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
try(stabilize_chr(c("hide", "find", "find", "hide"), regex = "hide"))
#> Error in eval(expr, envir) : 
#>   `c("hide", "find", "find", "hide")` must match the regex pattern "hide"
#> ✖ Some values fail the check.
#> ✖ Locations: 2 and 3
#> ✖ Values: find and find

stabilize_chr_scalar(TRUE)
#> [1] "TRUE"
stabilize_chr_scalar("TRUE")
#> [1] "TRUE"
try(stabilize_chr_scalar(c(TRUE, FALSE, TRUE)))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, FALSE, TRUE)` must be a single <character>.
#> ✖ `c(TRUE, FALSE, TRUE)` has 3 values.
stabilize_chr_scalar(NULL)
#> NULL
try(stabilize_chr_scalar(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
```
