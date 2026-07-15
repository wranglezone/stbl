# Convert a value to a target type

`to()` coerces `x` to the type of `.to`, dispatching on the class of
`.to` to the appropriate `to_*()` function.

## Usage

``` r
to(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'character'
to(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'double'
to(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'data.frame'
to(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'factor'
to(
  x,
  .to,
  ...,
  levels = NULL,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`function`'
to(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'integer'
to(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'logical'
to(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class 'list'
to(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# S3 method for class '`NULL`'
to(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

# Default S3 method
to(
  x,
  .to,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The argument to stabilize.

- .to:

  A prototype that determines the target type (e.g.,
  [`integer()`](https://rdrr.io/r/base/integer.html),
  `factor(levels = c("a", "b"))`).

- ...:

  Arguments passed to methods and on to `to_*()` functions.

- x_arg:

  `(length-1 character)` The name of the argument being stabilized to
  use in error messages. The automatic value will work in most cases, or
  pass it through from higher-level functions to make error messages
  clearer in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- x_class:

  `(length-1 character)` The class name of the argument being stabilized
  to use in error messages. Use this if you remove a special class from
  the object before checking its coercion, but want the error message to
  match the original class.

- levels:

  `(character)` The desired factor levels.

## Value

`x` coerced to the type of `.to`.

## See also

Other character functions:
[`are_chr_ish()`](https://stbl.wrangle.zone/dev/reference/are_chr_ish.md),
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md)

Other double functions:
[`are_dbl_ish()`](https://stbl.wrangle.zone/dev/reference/are_dbl_ish.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md)

Other integer functions:
[`are_int_ish()`](https://stbl.wrangle.zone/dev/reference/are_int_ish.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md)

Other logical functions:
[`are_lgl_ish()`](https://stbl.wrangle.zone/dev/reference/are_lgl_ish.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)

Other factor functions:
[`are_fct_ish()`](https://stbl.wrangle.zone/dev/reference/are_fct_ish.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md)

Other function functions:
[`are_fn_ish()`](https://stbl.wrangle.zone/dev/reference/are_fn_ish.md),
[`to_fn()`](https://stbl.wrangle.zone/dev/reference/to_fn.md)

Other list functions:
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`stabilize_present()`](https://stbl.wrangle.zone/dev/reference/stabilize_present.md),
[`to_lst()`](https://stbl.wrangle.zone/dev/reference/to_lst.md)

Other data frame functions:
[`specify_df()`](https://stbl.wrangle.zone/dev/reference/specify_df.md),
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md),
[`to_df()`](https://stbl.wrangle.zone/dev/reference/to_df.md)

## Examples

``` r
to(1L, double())
#> [1] 1
to(1.0, integer())
#> [1] 1
to(TRUE, character())
#> [1] "TRUE"
to("1", integer())
#> [1] 1
to(c("a", "b"), factor(levels = c("a", "b", "c")))
#> [1] a b
#> Levels: a b c
to("mean", mean)
#> function (x, ...) 
#> UseMethod("mean")
#> <bytecode: 0x5594eef24130>
#> <environment: namespace:base>
```
