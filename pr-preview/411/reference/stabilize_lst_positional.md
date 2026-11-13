# Ensure a list meets positional (tuple) expectations

Validate a list as a tuple: the *i*th spec in `...` is applied to the
*i*th element of `.x`. This mirrors JSON Schema's `prefixItems`.
`stabilise_lst_positional()`, `stabilize_list_positional()`,
`stabilise_list_positional()`, `stabilize_tuple()`, and
`stabilise_tuple()` are synonyms.

## Usage

``` r
stabilize_lst_positional(
  .x,
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE,
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
)

stabilise_lst_positional(
  .x,
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE,
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
)

stabilize_list_positional(
  .x,
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE,
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
)

stabilise_list_positional(
  .x,
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE,
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
)

stabilize_tuple(
  .x,
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE,
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
)

stabilise_tuple(
  .x,
  ...,
  .additional = NULL,
  .n_required = ...length(),
  .unique = FALSE,
  .allow_null = TRUE,
  .allow_zero_length = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .simplify = FALSE,
  .coerce_function = FALSE,
  .x_arg = caller_arg(.x),
  .call = caller_env(),
  .x_class = object_type(.x)
)
```

## Arguments

- .x:

  The object to stabilize.

- ...:

  Unnamed stabilizer functions, such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc), `to_*` functions, or functions produced by `specify_*()`
  functions
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc). The *i*th function validates the *i*th element of `.x`. At least
  one function is required.

- .additional:

  Controls how elements of `.x` after the last spec in `...` are
  handled. One of:

  - `NULL` or `FALSE` (default): any extra elements cause an error.

  - `TRUE`: extra elements are allowed, unchecked.

  - A single stabilizer function, used to validate every extra element.

- .n_required:

  `(integer(1))` The number of leading positions that must be present in
  `.x`. Defaults to all of them. Must be between 0 and the number of
  specs. A zero-length `.x` (such as
  [`list()`](https://rdrr.io/r/base/list.html)) skips this check when
  `.allow_zero_length = TRUE`. This is independent of `.min_size` and
  `.max_size`, which check the total length.

- .unique:

  (`logical(1)`) Should all elements in `x` be distinct?

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

- .simplify:

  (`logical(1)`) Should per-element results be combined into a single
  atomic vector when possible (every result has size 1 and shares a
  common type)? If `FALSE`, a list is always returned.

- .coerce_function:

  (`logical(1)`) Should functions be converted?

- .x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- .x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its conversion, but want the error message to
  match the original class.

## Value

The validated list (or an atomic vector when `.simplify = TRUE` and
simplification is possible), or an error condition with classes
`<stbl-error>`, `<stbl-condition>`, `<rlang_error>`, `<error>`,
`<condition>`, and a specific class by failure mode:

- `<stbl-error-bad_null>` for `NULL` values when `.allow_null = FALSE`.

- `<stbl-error-coerce-list>` when `.x` cannot be converted to a list.

- `<stbl-error-bad_function>` for functions when
  `.coerce_function = FALSE` (the default).

- `<stbl-error-size_too_small>` when the list is shorter than
  `.min_size`.

- `<stbl-error-size_too_large>` when the list is longer than
  `.max_size`.

- `<stbl-error-empty_specs>` when no specs are provided.

- `<stbl-error-named_spec>` when any spec passed through `...` is named.

- `<stbl-error-bad_n_required>` when `.n_required` is out of range.

- `<stbl-error-bad_named>` when `.x` has named elements.

- `<stbl-error-missing_element>` when `.x` has fewer than `.n_required`
  elements.

- `<stbl-error-bad_additional>` when extra elements are present but
  `.additional` is `NULL` or `FALSE`.

- `<stbl-error-cant_stabilize_positional>` when any element fails its
  spec; the condition's `locations` element gives the positions that
  failed.

- `<stbl-error-duplicate_elements>` when `.unique = TRUE` and duplicate
  elements are present.

## See also

Other list functions:
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md),
[`specify_lst_positional()`](https://stbl.wrangle.zone/dev/reference/specify_lst_positional.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`to()`](https://stbl.wrangle.zone/dev/reference/to.md),
[`to_lst()`](https://stbl.wrangle.zone/dev/reference/to_lst.md)

Other stabilization functions:
[`assert_contains()`](https://stbl.wrangle.zone/dev/reference/assert_contains.md),
[`assert_not()`](https://stbl.wrangle.zone/dev/reference/assert_not.md),
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
[`stabilize_all_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_all_of.md),
[`stabilize_any_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_any_of.md),
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr_scalar.md),
[`stabilize_date()`](https://stbl.wrangle.zone/dev/reference/stabilize_date.md),
[`stabilize_date_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_date_scalar.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl_scalar.md),
[`stabilize_df()`](https://stbl.wrangle.zone/dev/reference/stabilize_df.md),
[`stabilize_dttm()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm.md),
[`stabilize_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm_scalar.md),
[`stabilize_dur()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur.md),
[`stabilize_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur_scalar.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct_scalar.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_int_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_int_scalar.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md),
[`stabilize_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl_scalar.md),
[`stabilize_lst()`](https://stbl.wrangle.zone/dev/reference/stabilize_lst.md),
[`stabilize_names()`](https://stbl.wrangle.zone/dev/reference/stabilize_names.md),
[`stabilize_one_of()`](https://stbl.wrangle.zone/dev/reference/stabilize_one_of.md),
[`stabilize_time()`](https://stbl.wrangle.zone/dev/reference/stabilize_time.md),
[`stabilize_time_scalar()`](https://stbl.wrangle.zone/dev/reference/stabilize_time_scalar.md),
[`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
[`to_chr_scalar()`](https://stbl.wrangle.zone/dev/reference/to_chr_scalar.md),
[`to_date()`](https://stbl.wrangle.zone/dev/reference/to_date.md),
[`to_date_scalar()`](https://stbl.wrangle.zone/dev/reference/to_date_scalar.md),
[`to_dbl()`](https://stbl.wrangle.zone/dev/reference/to_dbl.md),
[`to_dbl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dbl_scalar.md),
[`to_dttm()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md),
[`to_dttm_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dttm_scalar.md),
[`to_dur()`](https://stbl.wrangle.zone/dev/reference/to_dur.md),
[`to_dur_scalar()`](https://stbl.wrangle.zone/dev/reference/to_dur_scalar.md),
[`to_fct()`](https://stbl.wrangle.zone/dev/reference/to_fct.md),
[`to_fct_scalar()`](https://stbl.wrangle.zone/dev/reference/to_fct_scalar.md),
[`to_int()`](https://stbl.wrangle.zone/dev/reference/to_int.md),
[`to_int_scalar()`](https://stbl.wrangle.zone/dev/reference/to_int_scalar.md),
[`to_lgl()`](https://stbl.wrangle.zone/dev/reference/to_lgl.md),
[`to_lgl_scalar()`](https://stbl.wrangle.zone/dev/reference/to_lgl_scalar.md),
[`to_time()`](https://stbl.wrangle.zone/dev/reference/to_time.md),
[`to_time_scalar()`](https://stbl.wrangle.zone/dev/reference/to_time_scalar.md)

## Examples

``` r
# [lon, lat]
stabilize_lst_positional(
  list(-122.4, 37.8),
  stabilize_dbl_scalar,
  stabilize_dbl_scalar
)
#> [[1]]
#> [1] -122.4
#> 
#> [[2]]
#> [1] 37.8
#> 

# An address tuple: [number, street, street type, direction]
stabilize_lst_positional(
  list(1600, "Pennsylvania", "Avenue", "NW"),
  specify_dbl_scalar(),
  specify_chr_scalar(),
  specify_chr_scalar(allowed_values = c("Street", "Avenue", "Boulevard")),
  specify_chr_scalar(allowed_values = c("NW", "NE", "SW", "SE"))
)
#> [[1]]
#> [1] 1600
#> 
#> [[2]]
#> [1] "Pennsylvania"
#> 
#> [[3]]
#> [1] "Avenue"
#> 
#> [[4]]
#> [1] "NW"
#> 

# Trailing positions can be optional
stabilize_lst_positional(
  list(1600, "Pennsylvania"),
  specify_dbl_scalar(),
  specify_chr_scalar(),
  specify_chr_scalar(),
  .n_required = 2
)
#> [[1]]
#> [1] 1600
#> 
#> [[2]]
#> [1] "Pennsylvania"
#> 

# Allow and validate extra elements
stabilize_lst_positional(
  list("a", 1L, 2L, 3L),
  stabilize_chr_scalar,
  .additional = stabilize_int_scalar
)
#> [[1]]
#> [1] "a"
#> 
#> [[2]]
#> [1] 1
#> 
#> [[3]]
#> [1] 2
#> 
#> [[4]]
#> [1] 3
#> 

# Simplify to an atomic vector when possible
stabilize_lst_positional(
  list(1.5, 2L),
  stabilize_dbl_scalar,
  stabilize_int_scalar,
  .simplify = TRUE
)
#> [1] 1.5 2.0

# Every failing position is reported
try(
  stabilize_lst_positional(
    list("a", "b", "c"),
    stabilize_chr_scalar,
    stabilize_int_scalar,
    stabilize_lgl_scalar
  )
)
#> Error in eval(expr, envir) : 
#>   `list("a", "b", "c")` <list> must satisfy the spec at every position.
#> ✖ Position 2: `list("a", "b", "c")[[2]]` <character> must be convertible to
#>   <integer> (Locations: 1)
#> ✖ Position 3: `list("a", "b", "c")[[3]]` <character> must be convertible to
#>   <logical> (Locations: 1)
```
