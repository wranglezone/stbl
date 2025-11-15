# Ensure a double argument meets expectations

`to_dbl()` checks whether an argument can be coerced to double without
losing information, returning it silently if so. Otherwise an
informative error message is signaled. `to_double` is a synonym of
`to_dbl()`.

`stabilize_dbl()` can check more details about the argument, but is
slower than `to_dbl()`. `stabilise_dbl()`, `stabilize_double()`, and
`stabilise_double()` are synonyms of `stabilize_dbl()`.

`stabilize_dbl_scalar()` and `to_dbl_scalar()` are optimized to check
for length-1 double vectors. `stabilise_dbl_scalar`,
`stabilize_double_scalar()`, and `stabilise_double_scalar` are synonyms
of `stabilize_dbl_scalar()`, and `to_double_scalar()` is a synonym of
`to_dbl_scalar()`.

## Usage

``` r
stabilize_dbl(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_double(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_dbl(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_double(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_size = NULL,
  max_size = NULL,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_dbl_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_double_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_dbl_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_double_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  coerce_character = TRUE,
  coerce_factor = TRUE,
  min_value = NULL,
  max_value = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_dbl(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_double(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_dbl(x, ..., allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())

# S3 method for class 'character'
to_dbl(
  x,
  ...,
  coerce_character = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'factor'
to_dbl(
  x,
  ...,
  coerce_factor = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_dbl_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_double_scalar(
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

- coerce_character:

  `(length-1 logical)` Should character vectors such as "1" and "2.0" be
  considered numeric-ish?

- coerce_factor:

  `(length-1 logical)` Should factors with values such as "1" and "2.0"
  be considered numeric-ish? Note that this package uses the character
  value from the factor, while
  [`as.integer()`](https://rdrr.io/r/base/integer.html) and
  [`as.double()`](https://rdrr.io/r/base/double.html) use the integer
  index of the factor.

- min_size:

  `(length-1 integer)` The minimum size of the object. Object size will
  be tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- max_size:

  `(length-1 integer)` The maximum size of the object. Object size will
  be tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- min_value:

  `(length-1 numeric)` The lowest allowed value for `x`. If `NULL`
  (default) values are not checked.

- max_value:

  `(length-1 numeric)` The highest allowed value for `x`. If `NULL`
  (default) values are not checked.

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

The argument as a double vector.

## See also

Other double functions:
[`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md)

Other stabilization functions:
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)

## Examples

``` r
to_dbl(1:10)
#>  [1]  1  2  3  4  5  6  7  8  9 10
to_dbl("1.1")
#> [1] 1.1
to_dbl(1 + 0i)
#> [1] 1
to_dbl(NULL)
#> NULL
try(to_dbl("a"))
#> Error in eval(expr, envir) : 
#>   `"a"` <character> must be coercible to <double>
#> ✖ Can't convert some values due to incompatible values.
#> • Locations: 1
try(to_dbl("1.1", coerce_character = FALSE))
#> Error in eval(expr, envir) : 
#>   Can't coerce `"1.1"` <character> to <double>.

to_dbl_scalar("1.1")
#> [1] 1.1
try(to_dbl_scalar(1:10))
#> Error in eval(expr, envir) : 
#>   `1:10` must be a single <numeric>.
#> ✖ `1:10` has 10 values.

stabilize_dbl(1:10)
#>  [1]  1  2  3  4  5  6  7  8  9 10
stabilize_dbl("1.1")
#> [1] 1.1
stabilize_dbl(1 + 0i)
#> [1] 1
stabilize_dbl(NULL)
#> NULL
try(stabilize_dbl(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
try(stabilize_dbl(c(1.1, NA), allow_na = FALSE))
#> Error in eval(expr, envir) : 
#>   `c(1.1, NA)` must not contain NA values.
#> • NA locations: 2
try(stabilize_dbl(letters))
#> Error in eval(expr, envir) : 
#>   `letters` <character> must be coercible to <double>
#> ✖ Can't convert some values due to incompatible values.
#> • Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, …,
#>   25, and 26
try(stabilize_dbl("1.1", coerce_character = FALSE))
#> Error in eval(expr, envir) : 
#>   Can't coerce `"1.1"` <character> to <double>.
try(stabilize_dbl(factor(c("1.1", "a"))))
#> Error in eval(expr, envir) : 
#>   `factor(c("1.1", "a"))` <factor> must be coercible to <double>
#> ✖ Can't convert some values due to incompatible values.
#> • Locations: 2
try(stabilize_dbl(factor("1.1"), coerce_factor = FALSE))
#> Error in eval(expr, envir) : 
#>   Can't coerce `factor("1.1")` <factor> to <double>.
try(stabilize_dbl(1:10, min_value = 3.5))
#> Error in eval(expr, envir) : 
#>   ! Values of `1:10` must be >= 3.5.
#> ✖ Values are too low at locations 1, 2, and 3.
try(stabilize_dbl(1:10, max_value = 7.5))
#> Error in eval(expr, envir) : 
#>   ! Values of `1:10` must be <= 7.5.
#> ✖ Values are too high at locations 8, 9, and 10.

stabilize_dbl_scalar(1.0)
#> [1] 1
stabilize_dbl_scalar("1.1")
#> [1] 1.1
try(stabilize_dbl_scalar(1:10))
#> Error in eval(expr, envir) : 
#>   `1:10` must be a single <numeric>.
#> ✖ `1:10` has 10 values.
stabilize_dbl_scalar(NULL)
#> NULL
try(stabilize_dbl_scalar(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
```
