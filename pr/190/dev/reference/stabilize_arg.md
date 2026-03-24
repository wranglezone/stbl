# Ensure an argument meets expectations

`stabilize_arg()` is used by other functions such as
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md).
Use `stabilize_arg()` if the type-specific functions will not work for
your use case, but you would still like to check things like size or
whether the argument is NULL.

`stabilize_arg_scalar()` is optimized to check for length-1 vectors.

## Usage

``` r
stabilize_arg(
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

stabilize_arg_scalar(
  x,
  ...,
  allow_null = TRUE,
  allow_zero_length = TRUE,
  allow_na = TRUE,
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

`x`, unless one of the checks fails.

## See also

Other stabilization functions:
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)

## Examples

``` r
wrapper <- function(this_arg, ...) {
  stabilize_arg(this_arg, ...)
}
wrapper(1)
#> [1] 1
wrapper(NULL)
#> NULL
wrapper(NA)
#> [1] NA
try(wrapper(NULL, allow_null = FALSE))
#> Error in wrapper(NULL, allow_null = FALSE) : 
#>   `this_arg` must not be <NULL>.
try(wrapper(NA, allow_na = FALSE))
#> Error in wrapper(NA, allow_na = FALSE) : 
#>   `this_arg` must not contain NA values.
#> • NA locations: 1
try(wrapper(1, min_size = 2))
#> Error in wrapper(1, min_size = 2) : 
#>   `this_arg` must have size >= 2.
#> ✖ 1 is too small.
try(wrapper(1:10, max_size = 5))
#> Error in wrapper(1:10, max_size = 5) : 
#>   `this_arg` must have size <= 5.
#> ✖ 10 is too big.
stabilize_arg_scalar("a")
#> [1] "a"
stabilize_arg_scalar(1L)
#> [1] 1
try(stabilize_arg_scalar(1:10))
#> Error in eval(expr, envir) : 
#>   `1:10` must be a single <integer>.
#> ✖ `1:10` has 10 values.
```
