# Ensure a list meets expectations

`to_lst()` checks whether an object can be coerced to a list without
losing information, returning it silently if so. Otherwise an
informative error message is signaled. `to_list()` is a synonym of
`to_lst()`.

## Usage

``` r
to_lst(x, ..., x_arg = caller_arg(x), call = caller_env())

to_list(x, ..., x_arg = caller_arg(x), call = caller_env())

# S3 method for class 'list'
to_lst(x, ..., x_arg = caller_arg(x), call = caller_env())

# Default S3 method
to_lst(x, ..., x_arg = caller_arg(x), call = caller_env())

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

  The object to stabilize.

- ...:

  Arguments passed to
  [`base::as.list()`](https://rdrr.io/r/base/list.html) or other
  methods.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- coerce_function:

  (`logical(1)`) Should functions be coerced?

## Value

The object as a list.

## Details

This function has important distinctions from
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

## See also

Other list functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md)
