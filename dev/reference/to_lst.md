# Ensure a list argument meets expectations

`to_list()` checks whether an argument can be coerced to a list without
losing information, returning it silently if so. Otherwise an
informative error message is signaled. `to_lst()` is a synonym of
`to_list()`.

## Usage

``` r
to_lst(x, ..., x_arg = caller_arg(x), call = caller_env())

to_list(x, ..., x_arg = caller_arg(x), call = caller_env())

# S3 method for class 'list'
to_lst(x, ...)

# Default S3 method
to_lst(x, ...)

# S3 method for class '`NULL`'
to_lst(x, ..., allow_null = TRUE, x_arg = caller_arg(x), call = caller_env())

# S3 method for class '`function`'
to_lst(
  x,
  ...,
  coerce_function = FALSE,
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The argument to stabilize.

- ...:

  Arguments passed to
  [`base::as.list()`](https://rdrr.io/r/base/list.html) or other
  methods.

- x_arg:

  `(length-1 character)` An argument name for x. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- allow_null:

  `(length-1 logical)` Is NULL an acceptable value?

- coerce_function:

  `(length-1 logical)` Should functions be coerced?

## Value

The argument as a list.

## Details

This function has three important distinctions from
[`base::as.list()`](https://rdrr.io/r/base/list.html):

- Functions can be rejected as part of the call to this function (with
  `coerce_function = FALSE`, the default). If they are allowed, they'll
  be coerced to a list concatenating their formals and body (as with
  [`base::as.list()`](https://rdrr.io/r/base/list.html).

- Primitive functions (such as
  [`base::is.na()`](https://rdrr.io/r/base/NA.html) or
  [`base::is.list()`](https://rdrr.io/r/base/list.html)) always throw an
  error, rather than returning `list(NULL)`.

- `NULL` values can be rejected as part of the call to this function
  (with `allow_null = FALSE`).
