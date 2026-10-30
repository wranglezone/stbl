# Ensure a list meets expectations

`to_lst()` checks whether an object can be converted to a list without
losing information, returning it silently if so. Otherwise an
informative error message is signaled. `to_list()` is a synonym of
`to_lst()`.

## Usage

``` r
to_lst(
  x,
  ...,
  coerce_function = FALSE,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env()
)

to_list(
  x,
  ...,
  coerce_function = FALSE,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env()
)

# S3 method for class 'list'
to_lst(
  x,
  ...,
  coerce_function = FALSE,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env()
)

# Default S3 method
to_lst(
  x,
  ...,
  coerce_function = FALSE,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to_lst(
  x,
  ...,
  allow_null = TRUE,
  coerce_function = FALSE,
  x_arg = caller_arg(x),
  to_arg = NULL,
  call = caller_env()
)

# S3 method for class '`function`'
to_lst(
  x,
  ...,
  coerce_function = FALSE,
  x_arg = caller_arg(x),
  to_arg = NULL,
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

- coerce_function:

  (`logical(1)`) Should functions be converted?

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- to_arg:

  (`character(1)` or `NULL`) The name of the object that `x` is being
  converted to match, for use in error messages. When `NULL`, error
  messages describe only `x`. When supplied, conversion failure messages
  name both `x_arg` and `to_arg`.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its conversion, but want the error message to
  match the original class.

- allow_null:

  (`logical(1)`) Is NULL an acceptable value?

## Value

The object as a list, or an error condition with classes `<stbl-error>`,
`<stbl-condition>`, `<rlang_error>`, `<error>`, `<condition>`, and a
specific class by failure mode:

- `<stbl-error-coerce-list>` when `x` is a primitive function.

- `<stbl-error-bad_function>` for functions when
  `coerce_function = FALSE` (the default).

- `<stbl-error-bad_null>` for `NULL` values when `allow_null = FALSE`.

## Details

This function has important distinctions from
[`base::as.list()`](https://rdrr.io/r/base/list.html):

- Functions can be rejected as part of the call to this function (with
  `coerce_function = FALSE`, the default). If they are allowed, they'll
  be converted to a list concatenating their formals and body (as with
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
