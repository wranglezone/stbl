# Ensure a logical argument meets expectations

`to_lgl()` checks whether an argument can be coerced to logical without
losing information, returning it silently if so. Otherwise an
informative error message is signaled. `to_logical` is a synonym of
`to_lgl()`.

`stabilize_lgl()` can check more details about the argument, but is
slower than `to_lgl()`. `stabilise_lgl()`, `stabilize_logical()`, and
`stabilise_logical()` are synonyms of `stabilize_lgl()`.

`stabilize_lgl_scalar()` and `to_lgl_scalar()` are optimized to check
for length-1 logical vectors. `stabilise_lgl_scalar()`,
`stabilize_logical_scalar()`, and `stabilise_logical_scalar()` are
synonyms of `stabilize_lgl_scalar()`, and `to_logical_scalar()` is a
synonym of `to_lgl_scalar()`.

## Usage

``` r
stabilize_lgl(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_logical(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_lgl(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_logical(
  x,
  ...,
  allow_null = TRUE,
  allow_na = TRUE,
  min_size = NULL,
  max_size = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_lgl_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilize_logical_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_lgl_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_logical_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_lgl(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_logical(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_lgl(x, ..., allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())

to_lgl_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_logical_scalar(
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

The argument as a logical vector.

## See also

Other logical functions:
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md)

Other stabilization functions:
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md)

## Examples

``` r
to_lgl(TRUE)
#> [1] TRUE
to_lgl("TRUE")
#> [1] TRUE
to_lgl(1:10)
#>  [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
to_lgl(NULL)
#> NULL
try(to_lgl(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
try(to_lgl(letters))
#> Error in eval(expr, envir) : 
#>   `letters` <character> must be coercible to <logical>
#> ✖ Can't convert some values due to incompatible values.
#> • Locations: 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, …,
#>   25, and 26
try(to_lgl(list(TRUE)))
#> [1] TRUE

to_lgl_scalar("TRUE")
#> [1] TRUE
try(to_lgl_scalar(c(TRUE, FALSE)))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, FALSE)` must be a single <logical>.
#> ✖ `c(TRUE, FALSE)` has 2 values.

stabilize_lgl(c(TRUE, FALSE, TRUE))
#> [1]  TRUE FALSE  TRUE
stabilize_lgl("true")
#> [1] TRUE
stabilize_lgl(NULL)
#> NULL
try(stabilize_lgl(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
try(stabilize_lgl(c(TRUE, NA), allow_na = FALSE))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, NA)` must not contain NA values.
#> • NA locations: 2
try(stabilize_lgl(letters))
#> Error in eval(expr, envir) : 
#>   `letters` <character> must be coercible to <logical>
#> ✖ Can't convert some values due to incompatible values.
#> • Locations: 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, …,
#>   25, and 26
try(stabilize_lgl(c(TRUE, FALSE, TRUE), min_size = 5))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, FALSE, TRUE)` must have size >= 5.
#> ✖ 3 is too small.
try(stabilize_lgl(c(TRUE, FALSE, TRUE), max_size = 2))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, FALSE, TRUE)` must have size <= 2.
#> ✖ 3 is too big.

stabilize_lgl_scalar(TRUE)
#> [1] TRUE
stabilize_lgl_scalar("TRUE")
#> [1] TRUE
try(stabilize_lgl_scalar(c(TRUE, FALSE, TRUE)))
#> Error in eval(expr, envir) : 
#>   `c(TRUE, FALSE, TRUE)` must be a single <logical>.
#> ✖ `c(TRUE, FALSE, TRUE)` has 3 values.
stabilize_lgl_scalar(NULL)
#> NULL
try(stabilize_lgl_scalar(NULL, allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.
```
