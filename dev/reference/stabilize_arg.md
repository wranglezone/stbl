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
  unique = FALSE,
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

- allow_zero_length:

  (`logical(1)`) Are zero-length vectors acceptable?

## Value

`x`, or an error condition with classes `<stbl-error>`,
`<stbl-condition>`, `<rlang_error>`, `<error>`, `<condition>`, and a
specific class by failure mode:

- `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.

- `<stbl-error-bad_na>` for `NA` values when `allow_na = FALSE`.

- `<stbl-error-size_too_small>` when the vector is shorter than
  `min_size`.

- `<stbl-error-size_too_large>` when the vector is longer than
  `max_size`.

- `<stbl-error-bad_empty>` for empty vectors when
  `allow_zero_length = FALSE` in `stabilize_arg_scalar()`.

- `<stbl-error-non_scalar>` for non-scalar vectors in
  `stabilize_arg_scalar()`.

## See also

Other stabilization functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
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
