# Check the size of an object

Checks if the size of `x` (from
[`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html))
is within the bounds of `min_size` and `max_size`.

## Usage

``` r
.check_size(x, min_size, max_size, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The object to check.

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

## Value

`NULL`, invisibly, if `x` passes the check.
