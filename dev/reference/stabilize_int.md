# Ensure an integer argument meets expectations

`to_int()` checks whether an argument can be coerced to integer without
losing information, returning it silently if so. Otherwise an
informative error message is signaled. `to_integer` is a synonym of
`to_int()`.

`stabilize_int()` can check more details about the argument, but is
slower than `to_int()`. `stabilise_int()`, `stabilize_integer()`, and
`stabilise_integer()` are synonyms of `stabilize_int()`.

`stabilize_int_scalar()` and `to_int_scalar()` are optimized to check
for length-1 integer vectors. `stabilise_int_scalar`,
`stabilize_integer_scalar()`, and `stabilise_integer_scalar` are
synonyms of `stabilize_int_scalar()`, and `to_integer_scalar()` is a
synonym of `to_int_scalar()`.

## Usage

``` r
stabilize_int(
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

stabilize_integer(
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

stabilise_int(
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

stabilise_integer(
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

stabilize_int_scalar(
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

stabilize_integer_scalar(
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

stabilise_int_scalar(
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

stabilise_integer_scalar(
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

to_int(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_integer(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_int(x, ..., allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())

# S3 method for class 'character'
to_int(
  x,
  ...,
  coerce_character = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'factor'
to_int(
  x,
  ...,
  coerce_factor = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_int_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_integer_scalar(
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

The argument as an integer vector.

## See also

Other integer functions:
[`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md)

Other stabilization functions:
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)

## Examples

``` r
to_int(1:10)
#>  [1]  1  2  3  4  5  6  7  8  9 10
to_int("1")
#> [1] 1
to_int(1 + 0i)
#> [1] 1
to_int(NULL)
#> NULL
try(to_int(c(1, 2, 3.1, 4, 5.2)))
#> Error in eval(expr, envir) : 
#>   Can't convert from `c(1, 2, 3.1, 4, 5.2)` <double> to <integer> due to loss of precision.
#> • Locations: 3, 5
try(to_int("1", coerce_character = FALSE))
#> Error in eval(expr, envir) : 
#>   Can't coerce `"1"` <character> to <integer>.
try(to_int(c("1", "2", "3.1", "4", "5.2")))
#> Error in eval(expr, envir) : 
#>   `c("1", "2", "3.1", "4", "5.2")` <character> must be coercible to
#> <integer>
#> ✖ Can't convert some values due to loss of precision.
#> • Locations: 3 and 5

to_int_scalar("1")
#> [1] 1
try(to_int_scalar(1:10))
#> Error in eval(expr, envir) : 
#>   `1:10` must be a single <integer>.
#> ✖ `1:10` has 10 values.

stabilize_int(1:10)
#>  [1]  1  2  3  4  5  6  7  8  9 10
stabilize_int("1")
#> [1] 1
stabilize_int(1 + 0i)
#> [1] 1
stabilize_int(NULL)
#> NULL
try(stabilize_int(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
try(stabilize_int(c(1, NA), allow_na = FALSE))
#> Error in eval(expr, envir) : 
#>   `c(1, NA)` must not contain NA values.
#> • NA locations: 2
try(stabilize_int(letters))
#> Error in eval(expr, envir) : 
#>   `letters` <character> must be coercible to <integer>
#> ✖ Can't convert some values due to incompatible values.
#> • Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, …,
#>   25, and 26
try(stabilize_int("1", coerce_character = FALSE))
#> Error in eval(expr, envir) : 
#>   Can't coerce `"1"` <character> to <integer>.
try(stabilize_int(factor(c("1", "a"))))
#> Error in eval(expr, envir) : 
#>   `factor(c("1", "a"))` <factor> must be coercible to <integer>
#> ✖ Can't convert some values due to incompatible values.
#> • Locations: 2
try(stabilize_int(factor("1"), coerce_factor = FALSE))
#> Error in eval(expr, envir) : 
#>   Can't coerce `factor("1")` <factor> to <integer>.
try(stabilize_int(1:10, min_value = 3))
#> Error in eval(expr, envir) : 
#>   ! Values of `1:10` must be >= 3.
#> ✖ Values are too low at locations 1 and 2.
try(stabilize_int(1:10, max_value = 7))
#> Error in eval(expr, envir) : 
#>   ! Values of `1:10` must be <= 7.
#> ✖ Values are too high at locations 8, 9, and 10.

stabilize_int_scalar(1L)
#> [1] 1
stabilize_int_scalar("1")
#> [1] 1
try(stabilize_int_scalar(1:10))
#> Error in eval(expr, envir) : 
#>   `1:10` must be a single <integer>.
#> ✖ `1:10` has 10 values.
stabilize_int_scalar(NULL)
#> NULL
try(stabilize_int_scalar(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
```
