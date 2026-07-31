# Try to coerce or validate x as one of several types

`stabilize_any_of()` attempts to validate and coerce `x` using each
function in `...` in order. It returns the result of the first function
that succeeds. If all functions fail, an informative error that combines
the individual failure messages is thrown. `stabilise_any_of()` is a
synonym.

`to_any_of()` is analogous to
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md): it tries to
coerce `x` to each type given in `...` (as a prototype such as
[`integer()`](https://rdrr.io/r/base/integer.html) or
[`character()`](https://rdrr.io/r/base/character.html)) and returns the
first successful result.

## Usage

``` r
stabilize_any_of(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_any_of(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

to_any_of(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The argument to stabilize.

- ...:

  For `stabilize_any_of()`: unnamed stabilizer or coercion functions,
  such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc.), `to_*` functions
  ([`to_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc.), or functions produced by `specify_*()` calls
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc.). For `to_any_of()`: prototype objects (e.g.
  [`integer()`](https://rdrr.io/r/base/integer.html),
  [`character()`](https://rdrr.io/r/base/character.html)) that determine
  the target types to try, passed as the `.to` argument of
  [`to()`](https://stbl.wrangle.zone/dev/reference/to.md).

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

## Value

`x` coerced or validated by the first successful function or prototype
in `...`.

## See also

Other stabilization functions:
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`stabilize_present()`](https://stbl.wrangle.zone/dev/reference/stabilize_present.md)

## Examples

``` r
# Returns x unchanged when the first function succeeds
stabilize_any_of(1L, stabilize_int, stabilize_chr)
#> [1] 1

# Falls through to stabilize_chr when stabilize_int fails
stabilize_any_of("a", stabilize_int, stabilize_chr)
#> [1] "a"

# Coerces via the first matching function ("1" -> 1L)
stabilize_any_of("1", stabilize_int, stabilize_chr)
#> [1] 1

# A mixed list falls through to stabilize_chr because "a" can't be integer
stabilize_any_of(list(1L, "a"), stabilize_int, stabilize_chr)
#> [1] "1" "a"

# Errors with a combined message when all functions fail
try(stabilize_any_of(list(1, TRUE, "23", "maybe"), stabilize_lgl, stabilize_int))
#> Error in eval(expr, envir) : 
#>   `list(1, TRUE, "23", "maybe")` must match at least one of the provided
#> stabilizers.
#> ✖ `list(1, TRUE, "23", "maybe")` <list> must be coercible to <logical>
#>   (Locations: 4)
#> ✖ `list(1, TRUE, "23", "maybe")` <list> must be coercible to <integer>
#>   (Locations: 4)
# to_any_of() uses prototypes instead of functions
to_any_of(1L, integer(), character())
#> [1] 1
to_any_of("a", integer(), character())
#> [1] "a"
to_any_of("1", integer(), character())
#> [1] 1
try(to_any_of(list(), integer(), character()))
#> integer(0)
```
