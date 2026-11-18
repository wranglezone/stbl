# Create a specified list stabilizer function

`specify_lst()` creates a function that will call
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md)
with the provided arguments. `specify_list()` is a synonym of
`specify_lst()`.

## Usage

``` r
specify_lst(
  ...,
  .patterns = NULL,
  .named = NULL,
  .unnamed = NULL,
  .allow_duplicate_names = FALSE,
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .required = ...names(),
  .coerce_function = FALSE,
  .simplify = FALSE
)

specify_list(
  ...,
  .patterns = NULL,
  .named = NULL,
  .unnamed = NULL,
  .allow_duplicate_names = FALSE,
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .required = ...names(),
  .coerce_function = FALSE,
  .simplify = FALSE
)
```

## Arguments

- ...:

  Named stabilizer functions, such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc) or functions produced by `specify_*()` functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). Each name corresponds to an element in `.x`, and the function is
  used to validate that element when present. Whether the element is
  required (its absence is an error) is controlled by `.required`.

- .patterns:

  `(list)` A named list of stabilizers, such as `specify_*()` results,
  `stabilize_*()` functions, or `to_*()` functions. Each name is a
  regular expression matched against the names of `.x`, and the spec is
  applied to every element whose name matches. Matching uses ICU regular
  expressions when the stringi package is installed (otherwise
  [`grepl()`](https://rdrr.io/r/base/grep.html)). An element matching
  any pattern is not an "extra" element, so `.named` does not apply to
  it. An element that matches several patterns, or a pattern and an
  exact spec in `...`, is checked by every matching spec and the results
  are combined with
  [`reconcile()`](https://stbl.wrangle.zone/dev/reference/reconcile.md).

- .named:

  Controls how named elements of `.x` that are *not* explicitly listed
  in `...` are handled. One of:

  - `NULL` (default): any extra named elements cause an error. Names in
    `.required` that have no spec in `...` are allowed, unchecked.

  - `FALSE`: any extra named elements cause an error, and every name in
    `.required` must have a spec in `...`.

  - `TRUE`: extra named elements are allowed, unchecked.

  - A single stabilizer function, such as a `stabilize_*` function
    ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
    etc) or a function produced by a `specify_*()` function
    ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
    etc), used to validate every extra named element.

- .unnamed:

  Controls how unnamed elements of `.x` are handled. One of:

  - `NULL` or `FALSE` (default): any unnamed elements cause an error.

  - `TRUE`: unnamed elements are allowed, unchecked.

  - A single stabilizer function, such as a `stabilize_*` function
    ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
    etc) or a function produced by a `specify_*()` function
    ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
    etc), used to validate every unnamed element.

- .allow_duplicate_names:

  (`logical(1)`) Should `x` be allowed to have duplicate names?

- .unique:

  (`logical(1)`) Should all elements in `.x` be distinct? If `TRUE`,
  duplicated elements are rejected.

- .allow_null:

  (`logical(1)`) Is NULL an acceptable value?

- .allow_zero_length:

  (`logical(1)`) Are zero-length vectors acceptable?

- .min_size:

  (`integer(1)`) The minimum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- .max_size:

  (`integer(1)`) The maximum size of the object. Object size will be
  tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- .required:

  `(character or list)` Names of elements that must be present in `.x`.
  Defaults to all names in `...`, so every named spec is required unless
  you opt it out. A supplied `.required` *replaces* that default, so
  `.required = list(credit_card = "billing_address")` makes every other
  spec optional; list the unconditional names explicitly. Specs for
  names that are not required are optional: if absent, no error is
  raised; if present, they're validated normally. Pass `NULL` or
  [`character()`](https://rdrr.io/r/base/character.html) to make every
  named spec optional. Every name in `.required` is enforced, whether or
  not it has a spec in `...` (see `.named`). A zero-length `.x` (such as
  [`list()`](https://rdrr.io/r/base/list.html)) skips this check when
  `.allow_zero_length = TRUE`. See `required` in \[stabilize_names)()\]
  for details on expressing conditional requirements.

  \[stabilize_names)()\]: R:stabilize_names)()

- .coerce_function:

  (`logical(1)`) Should functions be converted?

- .simplify:

  (`logical(1)`) Should per-element results be combined into a single
  atomic vector when possible (every result has size 1 and shares a
  common type)? If `FALSE`, a list is always returned.

## Value

A function of class `"stbl_specified_fn"` that calls
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md)
with the provided arguments. The generated function will also accept
`...` for additional named element specifications to pass to
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md).
You can copy/paste the body of the resulting function if you want to
provide additional context or functionality.

## See also

Other list functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`specify_lst_positional()`](https://stbl.wrangle.zone/dev/reference/specify_lst_positional.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`stabilize_lst_positional()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst_positional.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_lst()`](https://stbl.wrangle.zone/dev/reference/to_lst.md)

Other specification functions:
[`specify_all_of()`](https://stbl.wrangle.zone/dev/reference/specify_all_of.md),
[`specify_any_of()`](https://stbl.wrangle.zone/dev/reference/specify_any_of.md),
[`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
[`specify_date()`](https://stbl.wrangle.zone/dev/reference/specify_date.md),
[`specify_dbl()`](https://stbl.wrangle.zone/dev/reference/specify_dbl.md),
[`specify_df()`](https://stbl.wrangle.zone/dev/reference/specify_df.md),
[`specify_dttm()`](https://stbl.wrangle.zone/dev/reference/specify_dttm.md),
[`specify_dur()`](https://stbl.wrangle.zone/dev/reference/specify_dur.md),
[`specify_each()`](https://stbl.wrangle.zone/dev/reference/specify_each.md),
[`specify_fct()`](https://stbl.wrangle.zone/dev/reference/specify_fct.md),
[`specify_int()`](https://stbl.wrangle.zone/dev/reference/specify_int.md),
[`specify_lgl()`](https://stbl.wrangle.zone/dev/reference/specify_lgl.md),
[`specify_lst_positional()`](https://stbl.wrangle.zone/dev/reference/specify_lst_positional.md),
[`specify_names()`](https://stbl.wrangle.zone/dev/reference/specify_names.md),
[`specify_one_of()`](https://stbl.wrangle.zone/dev/reference/specify_one_of.md),
[`specify_time()`](https://stbl.wrangle.zone/dev/reference/specify_time.md)

## Examples

``` r
stabilize_config <- specify_lst(
  name = specify_chr_scalar(allow_na = FALSE),
  version = stabilize_int_scalar,
  debug = specify_lgl_scalar(allow_na = FALSE),
  .unnamed = stabilize_chr_scalar
)
stabilize_config(list(name = "myapp", version = 1L, debug = FALSE, "extra"))
#> $name
#> [1] "myapp"
#> 
#> $version
#> [1] 1
#> 
#> $debug
#> [1] FALSE
#> 
#> [[4]]
#> [1] "extra"
#> 
try(
  stabilize_config(
    list(name = "myapp", version = 1L, debug = FALSE, c("a", "b"))
  )
)
#> Error in eval(expr, envir) : 
#>   `list(name = "myapp", version = 1L, debug = FALSE, c("a", "b"))[[4]]`
#> must be a single <character>.
#> ✖ `list(name = "myapp", version = 1L, debug = FALSE, c("a", "b"))[[4]]` has 2
#>   values.

# Mark some elements as optional via .required
stabilize_settings <- specify_lst(
  name = specify_chr_scalar(),
  nickname = specify_chr_scalar(),
  .required = "name"
)
stabilize_settings(list(name = "Alice"))
#> $name
#> [1] "Alice"
#> 

# Require an element only when another is present
stabilize_payment <- specify_lst(
  name = specify_chr_scalar(),
  card = specify_int_scalar(),
  address = specify_chr_scalar(),
  .required = list("name", card = "address")
)
try(stabilize_payment(list(name = "Alice", card = 1L)))
#> Error in eval(expr, envir) : 
#>   `list(name = "Alice", card = 1L)` must contain element "address" when
#> "card" is present.
```
