# Coerce each element of x with a single spec

`to_each()` applies `spec` (a `to_*` function, `stabilize_*` function,
or `specify_*()` result) to every element of `x`, and stops at the first
element that fails. When every result has size 1 and shares a common
type, the results are simplified into a single atomic vector; otherwise
a list is returned.

## Usage

``` r
to_each(
  x,
  spec,
  ...,
  simplify = TRUE,
  x_arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  The object to stabilize.

- spec:

  `(function)` A single stabilizer or coercion function, such as a
  `to_*` function
  ([`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
  etc.), a `stabilize_*` function
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc.), or a function produced by a `specify_*()` call
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc.). Applied independently to each element of `x`.

- ...:

  Arguments passed to methods.

- simplify:

  (`logical(1)`) Should per-element results be combined into a single
  atomic vector when possible (every result has size 1 and shares a
  common type)? If `FALSE`, a list is always returned.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`x` with every element coerced by `spec`, simplified to an atomic vector
when `simplify = TRUE` and possible, otherwise a list. Errors with
whatever condition `spec` throws for the first failing element.

## See also

Other multiple type functions:
[`stabilize_each()`](https://stbl.wrangle.zone/dev/reference/stabilize_each.md)

## Examples

``` r
to_each(list("1", "2", "3"), to_int)
#> [1] 1 2 3
to_each(list(1L, 2L, 3L), to_chr)
#> [1] "1" "2" "3"

# Elements that can't be simplified into a common type stay a list
to_each(list(1L, "a"), specify_any_of(specify_int(), specify_chr()))
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] "a"
#> 

# Stops at the first element that fails
try(to_each(list("1", "a"), to_int))
#> Error in eval(expr, envir) : 
#>   `list("1", "a")[[2]]` <character> must be coercible to <integer>
#> ✖ Can't convert some values due to non-numeric strings.
#> • Locations: 1
#> • Values: "a"
```
