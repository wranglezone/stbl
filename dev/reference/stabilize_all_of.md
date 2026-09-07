# Try to coerce or validate x as all of several specs

`stabilize_all_of()` validates and coerces `x` by applying every
function in `...` to `x`, independently. `x` must satisfy every spec,
and all specs must agree on the coerced result; if any spec fails, or
specs disagree on the coerced value, an informative error is thrown.
`stabilise_all_of()` is a synonym.

## Usage

``` r
stabilize_all_of(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)

stabilise_all_of(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  The object to stabilize.

- ...:

  Unnamed stabilizer functions, such as `stabilize_*` functions
  ([`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
  etc.), `to_*` functions
  ([`to_chr()`](https://stbl.wrangle.zone/dev/reference/to_chr.md),
  etc.), functions produced by `specify_*()` calls
  ([`specify_chr()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md),
  etc.), or `assert_*()` functions (such as
  [`assert_not()`](https://stbl.wrangle.zone/dev/reference/assert_not.md))
  that return their input unchanged. Each is applied to the original
  `x`; `x` must pass every one of them, and they must all return the
  same value.

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

`x` coerced or validated by every function in `...`, or an error
condition with classes `<stbl-error>`, `<stbl-condition>`,
`<rlang_error>`, `<error>`, `<condition>`, and a specific class by
failure mode:

- `<stbl-error-empty_specs>` when no functions are supplied in `...`.

- `<stbl-error-named_spec>` when any element of `...` is named.

- `<stbl-error-cant_stabilize_all_of>` when any provided function fails.

- `<stbl-error-inconsistent_all_of>` when every function succeeds, but
  they don't all produce the same coerced value.

## See also

Other stabilization functions:
[`assert_not()`](https://stbl.wrangle.zone/dev/reference/assert_not.md),
[`assert_present()`](https://stbl.wrangle.zone/dev/reference/assert_present.md),
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
# Returns x unchanged when all functions succeed
stabilize_all_of(1L, stabilize_int, stabilize_int_scalar)
#> [1] 1

# Each spec is applied to the original x, independently
stabilize_all_of("ab", specify_chr(regex = "^a"), specify_chr(regex = "b$"))
#> [1] "ab"

# Errors with a combined message when a spec fails
try(stabilize_all_of("a", stabilize_int, stabilize_chr))
#> Error in eval(expr, envir) : 
#>   `"a"` must match all of the provided stabilizers.
#> ✖ `"a"` <character> must be coercible to <integer> (Locations: 1)

# Errors because each spec sees the original "1" (a string); the second
# spec would succeed on 1L, but doesn't get the chance to see it
try(stabilize_all_of("1", stabilize_int, specify_dbl(coerce_character = FALSE)))
#> Error in eval(expr, envir) : 
#>   `"1"` must match all of the provided stabilizers.
#> ✖ Can't coerce `"1"` <character> to <double>.

# Errors when specs succeed but disagree on the coerced value
# (stabilize_int() keeps 1L an integer; specify_dbl() makes it a double)
try(stabilize_all_of(1L, stabilize_int, specify_dbl()))
#> Error in eval(expr, envir) : 
#>   `1L` must be coerced the same way by every provided stabilizer.
#> ℹ The provided stabilizers succeeded, but disagreed on the coerced value.
```
