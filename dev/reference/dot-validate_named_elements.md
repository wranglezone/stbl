# Validate all named elements (required and extra)

Validate all named elements (required and extra)

## Usage

``` r
.validate_named_elements(
  .x,
  ...,
  .patterns,
  .named,
  .required,
  .allow_duplicate_names,
  .x_arg,
  .call
)
```

## Arguments

- .x:

  The object to stabilize.

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

- .allow_duplicate_names:

  (`logical(1)`) Should `x` be allowed to have duplicate names?

- .x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

The updated list.
