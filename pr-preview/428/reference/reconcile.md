# Reconcile equivalent values into their narrowest common representation

Check that every value in `...` is *equivalent* to every other value,
and return the narrowest representation of them. The result doesn't
depend on the order of the values.

## Usage

``` r
reconcile(..., call = caller_env())
```

## Arguments

- ...:

  The values to reconcile.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The narrowest common representation of the values in `...` if they are
all equivalent. A single value is returned unchanged. Otherwise, an
error condition with classes `<stbl-error>`, `<stbl-condition>`,
`<rlang_error>`, `<error>`, `<condition>`, and a specific class by
failure mode:

- `<stbl-error-cant_reconcile>` when any two values are not equivalent.
  The message names the pair that disagreed and, for nested values, the
  path to the first difference.

- `<stbl-error-empty_values>` when no values are supplied in `...`.

## Equivalence

Equivalence is defined by stbl's own conversions:

- Values of the same type are equivalent only if they are
  [`identical()`](https://rdrr.io/r/base/identical.html).

- Values of different types are equivalent when `identical(to(x, y), y)`
  and `identical(to(y, x), x)`. A failed conversion means "not
  equivalent".

Requiring both directions keeps lossy conversions out. For example,
`to_lgl(0.5)` is `TRUE`, but `to_dbl(TRUE)` is `1`, so `0.5` and `TRUE`
are not equivalent. Neither are `"1.0"` and `1L`, nor `"true"` and
`TRUE`.

Equivalent pairs include `1L` and `1`, `1L` and `TRUE`, `"1"` and `1L`,
`"TRUE"` and `TRUE`, `as.Date("2024-01-02")` and `"2024-01-02"`, and a
factor and the character vector of its labels. A factor and an ordered
factor are not equivalent, and neither are two factors with the same
labels but different levels, because those pairs have the same type and
are not identical. The same rule makes date-times with different time
zones not equivalent. `NA` matches only `NA`, and `NaN` matches only
`NaN`.

Conversions between Date and POSIXct values use the time zone of the
date-time value, so results don't depend on the time zone of your
session (unless the date-time has no time zone of its own).

Equivalence is not strictly transitive: `"TRUE"` is equivalent to
`TRUE`, and `TRUE` to `1L`, but `"TRUE"` is not equivalent to `1L`. When
`...` contains three or more values, every pair must be equivalent.

## Narrowest type

When values are equivalent, the result has the narrowest type of the
inputs, by this fixed ranking (narrowest first): factor, Date, POSIXct,
hms, Period, logical, integer, double, character. Classed types rank
ahead of their underlying types, so a result keeps the class a caller
asked for.

Values of a type outside the ranking (for example, classes handled by
the
[`vctrs::vec_cast()`](https://vctrs.r-lib.org/reference/vec_cast.html)
fallback in [`to()`](https://stbl.wrangle.zone/dev/reference/to.md)) are
equivalent only to values of the same class, compared with
[`vctrs::vec_equal()`](https://vctrs.r-lib.org/reference/vec_equal.html).

## Containers

Lists, data frames, `NULL`, and functions are separate categories, and
values of different categories are never equivalent. For example, `1:2`
and `list(1, 2)` are not equivalent, even though
[`to_lst()`](https://stbl.wrangle.zone/dev/reference/to_lst.md) and
[`to_int()`](https://stbl.wrangle.zone/dev/reference/to_int.md) convert
between them.

- **Lists** are reconciled element by element, with the same rules
  applied to every element. Length, names, and other attributes must
  match.

- **Data frames** are reconciled column by column. The class, row names,
  and column names and order must match.

- **Functions** and `NULL` are equivalent only when identical.

The result can combine the narrowest elements of its inputs, so it might
not equal any single input. For `list(a = 1L, b = 2)` and
`list(a = 1, b = 2L)`, the result is `list(a = 1L, b = 2L)`.

## See also

[`stabilize_all_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_all_of.md),
which uses `reconcile()` to combine the results of several specs.

Other multiple type functions:
[`specify_all_of()`](https://stbl.wrangle.zone/dev/reference/specify_all_of.md),
[`specify_any_of()`](https://stbl.wrangle.zone/dev/reference/specify_any_of.md),
[`specify_each()`](https://stbl.wrangle.zone/dev/reference/specify_each.md),
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md),
[`stabilize_all_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_all_of.md),
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md),
[`stabilize_each()`](https://stbl.wrangle.zone/dev/reference/stabilize_each.md),
[`stabilize_one_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_one_of.md),
[`to_each()`](https://stbl.wrangle.zone/dev/reference/to_each.md)

## Examples

``` r
reconcile(1L, 1)
#> [1] 1
reconcile(as.double(1:10), 1:10)
#>  [1]  1  2  3  4  5  6  7  8  9 10
reconcile("1", 1L, 1)
#> [1] 1

# The narrowest type wins, even for the elements of a list.
reconcile(list(a = 1L, b = 2), list(a = 1, b = 2L))
#> $a
#> [1] 1
#> 
#> $b
#> [1] 2
#> 

# Factors are equivalent to the character vector of their labels.
reconcile(c("a", "b"), factor(c("a", "b"), levels = c("b", "a")))
#> [1] a b
#> Levels: b a

# Lossy conversions are not equivalent.
try(reconcile(0.5, TRUE))
#> Error in eval(expr, envir) : `0.5` and `TRUE` must be equivalent.

# Nested differences are reported with their path.
try(reconcile(list(a = 1:2), list(a = c(1L, 3L))))
#> Error in eval(expr, envir) : 
#>   `list(a = 1:2)` and `list(a = c(1L, 3L))` must be equivalent.
#> ℹ The first difference is at `$a`.

# Values of the same type must be identical.
try(reconcile(
  factor(c("a", "b")),
  factor(c("a", "b"), levels = c("b", "a"))
))
#> Error in eval(expr, envir) : 
#>   `factor(c("a", "b"))` and `factor(c("a", "b"), levels = c("b", "a"))`
#> must be equivalent.
#> ✖ Levels differ.
```
