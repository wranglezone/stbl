# Ensure every element of x satisfies a single spec

`stabilize_each()` applies `spec` (a `to_*` function, `stabilize_*`
function, or `specify_*()` result) to every element of `x`
independently, collecting *every* failing location before erroring,
rather than stopping at the first failure like
[`to_each()`](https://stbl.wrangle.zone/dev/reference/to_each.md).
`stabilise_each()` is a synonym.

## Usage

``` r
stabilize_each(
  x,
  spec,
  ...,
  simplify = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_each(
  x,
  spec,
  ...,
  simplify = TRUE,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
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

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its coercion, but want the error message to
  match the original class.

## Value

`x` with every element coerced by `spec`, simplified to an atomic vector
when `simplify = TRUE` and possible, otherwise a list. Errors with
classes `<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
`<condition>`, and `<stbl-error-cant_stabilize_each>` when any element
fails `spec`; the condition's `locations` element gives the positions
that failed.

## See also

Other multiple type functions:
[`to_each()`](https://stbl.wrangle.zone/dev/reference/to_each.md)

## Examples

``` r
stabilize_each(list("1", "2", "3"), stabilize_int)
#> [1] 1 2 3
stabilize_each(list(1L, 2L, 3L), stabilize_chr)
#> [1] "1" "2" "3"

# Elements that can't be simplified into a common type stay a list
stabilize_each(list(1L, "a"), specify_any_of(specify_int(), specify_chr()))
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] "a"
#> 

# Reports every failing location, not just the first
try(stabilize_each(list("1", "a", "b"), stabilize_int))
#> Error in eval(expr, envir) : 
#>   `list("1", "a", "b")` <list> must have every element satisfy `spec`.
#> ✖ Location 2: `list("1", "a", "b")[[2]]` <character> must be coercible to
#>   <integer> (Locations: 1)
#> ✖ Location 3: `list("1", "a", "b")[[3]]` <character> must be coercible to
#>   <integer> (Locations: 1)
```
