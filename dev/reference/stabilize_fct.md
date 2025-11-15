# Ensure a factor argument meets expectations

`to_fct()` checks whether an argument can be coerced to a factor without
losing information, returning it silently if so. Otherwise an
informative error message is signaled. `to_factor` is a synonym of
`to_fct()`.

`stabilize_fct()` can check more details about the argument, but is
slower than `to_fct()`. `stabilise_fct()`, `stabilize_factor()`, and
`stabilise_factor()` are synonyms of `stabilize_fct()`.

`stabilize_fct_scalar()` and `to_fct_scalar()` are optimized to check
for length-1 factors. `stabilise_fct_scalar`,
`stabilize_factor_scalar()`, and `stabilise_factor_scalar` are synonyms
of `stabilize_fct_scalar()`, and `to_factor_scalar()` is a synonym of
`to_fct_scalar()`.

## Usage

``` r
stabilize_fct(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_factor(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_fct(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_factor(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_fct_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_factor_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_fct_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_factor_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_fct(
  x,
  ...,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_factor(
  x,
  ...,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_fct(x, ..., allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())

to_fct_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  levels = NULL,
  to_na = character(),
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_factor_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  levels = NULL,
  to_na = character(),
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

- levels:

  `(character)` Expected levels. If `NULL` (default), the levels will be
  computed by [`base::factor()`](https://rdrr.io/r/base/factor.html).

- to_na:

  `(character)` Values to convert to `NA`.

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

The argument as a factor.

## Details

These functions have important differences from
[`base::as.factor()`](https://rdrr.io/r/base/factor.html) and
[`base::factor()`](https://rdrr.io/r/base/factor.html):

- Values are never silently coerced to `NA` unless they are explicitly
  supplied in the `to_na` argument.

- `NULL` values can be rejected as part of the call to this function
  (with `allow_null = FALSE`).

## See also

Other factor functions:
[`are_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md)

Other stabilization functions:
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)

## Examples

``` r
to_fct("a")
#> [1] a
#> Levels: a
to_fct(1:10)
#>  [1] 1  2  3  4  5  6  7  8  9  10
#> Levels: 1 2 3 4 5 6 7 8 9 10
to_fct(NULL)
#> NULL
try(to_fct(letters[1:5], levels = c("a", "c"), to_na = "b"))
#> Error in eval(expr, envir) : 
#>   All values of `letters[1:5]` must be present in `levels` or `to_na`.
#> ℹ Disallowed values: d and e
#> ℹ Allowed values: a and c
#> ℹ Values that will be converted to `NA`: b

to_fct_scalar("a")
#> [1] a
#> Levels: a
try(to_fct_scalar(letters))
#> Error in eval(expr, envir) : 
#>   `letters` must be a single <factor>.
#> ✖ `letters` has 26 values.

stabilize_fct(letters)
#>  [1] a b c d e f g h i j k l m n o p q r s t u v w x y z
#> Levels: a b c d e f g h i j k l m n o p q r s t u v w x y z
try(stabilize_fct(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
try(stabilize_fct(c("a", NA), allow_na = FALSE))
#> Error in eval(expr, envir) : 
#>   `c("a", NA)` must not contain NA values.
#> • NA locations: 2
try(stabilize_fct(c("a", "b", "c"), min_size = 5))
#> Error in eval(expr, envir) : 
#>   `c("a", "b", "c")` must have size >= 5.
#> ✖ 3 is too small.
try(stabilize_fct(c("a", "b", "c"), max_size = 2))
#> Error in eval(expr, envir) : 
#>   `c("a", "b", "c")` must have size <= 2.
#> ✖ 3 is too big.

stabilize_fct_scalar("a")
#> [1] a
#> Levels: a
try(stabilize_fct_scalar(letters))
#> Error in eval(expr, envir) : 
#>   `letters` must be a single <factor>.
#> ✖ `letters` has 26 values.
try(stabilize_fct_scalar("c", levels = c("a", "b")))
#> Error in eval(expr, envir) : 
#>   All values of `"c"` must be present in `levels` or `to_na`.
#> ℹ Disallowed values: c
#> ℹ Allowed values: a and b
```
