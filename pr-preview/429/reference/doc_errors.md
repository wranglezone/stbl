# Document error subclasses

These internal helpers build the list of error subclasses in the
`@returns` section of a function's documentation. Include
`man/rmd/error-classes.md` as a child chunk to introduce the list, then
call `.doc_errors()` in a roxygen R chunk (with `results = "asis"` and
`echo = FALSE`) with one or more `.doc_err*()` entries. `.doc_errors()`
sorts the entries alphabetically by subclass and errors if a subclass is
documented more than once.

## Usage

``` r
.doc_errors(...)

.doc_err(subclass, text)

.doc_err_other(text)

.doc_err_null(arg = "allow_null")

.doc_err_na()

.doc_err_named()

.doc_err_allowed_names()

.doc_err_named_fn()

.doc_err_empty(fn = NULL)

.doc_err_scalar(fn = NULL)

.doc_err_size(
  what = "vector",
  min = "min_size",
  max = "max_size",
  fn = NULL,
  x_vs_y = TRUE
)

.doc_err_size_x_vs_y(
  min = "min_size",
  max = "max_size",
  also = NULL,
  fn = NULL
)

.doc_err_n_characters(scalar = FALSE)

.doc_err_regex()

.doc_err_tz(when = NULL)

.doc_err_range(exclusive = FALSE)

.doc_err_allowed_values(scalar = FALSE)

.doc_err_unique()

.doc_err_function()

.doc_err_fct_levels()

.doc_err_multiple_of()

.doc_err_not_multiple(scalar = FALSE)

.doc_err_coerce(class_name, description = class_name, extra = NULL)

.doc_err_incompatible(
  class_name,
  description = class_name,
  what = c("values", "elements")
)
```

## Arguments

- ...:

  `.doc_err*()` entries (or lists of entries).

- subclass:

  (`character`) The error subclass, as passed to
  [`.stbl_abort()`](https://stbl.wrangle.zone/dev/reference/dot-stbl_abort.md)
  (for example, `"bad_named"` or `c("coerce", "character")`), without
  the "stbl-error-" prefix.

- text:

  (`character(1)`) The description, starting with "when" or "for" and
  ending with a period. For `.doc_err_other()`, the full bullet text.

- arg:

  (`character(1)`) The name of the argument that controls the check.

- fn:

  (`character(1)`) Optional name of the function (without parentheses)
  to mention, for entries that only apply to one function.

- what:

  (`character(1)`) What can't be converted: `"values"` (the default) or
  `"elements"` (for list inputs).

- min, max:

  (`character(1)`) Names of the arguments that bound the size.

- x_vs_y:

  (`logical(1)`) Whether to include the `size_x_vs_y` entry.

- also:

  (`character(2)`) Optional second pair of min and max argument names
  for `size_x_vs_y`.

- scalar:

  (`logical(1)`) Whether the entry describes a single value rather than
  a vector.

- when:

  (`character(1)`) Optional condition that must hold before `tz` is
  checked.

- exclusive:

  (`logical(1)`) Whether the range also has exclusive bounds.

- class_name:

  (`character(1)`) The name of the target class as used in the subclass
  (for example, `"integer"`).

- description:

  (`character(1)`) The description of the target class as used in the
  text (defaults to `class_name`).

- extra:

  (`character(1)`) Optional text appended to the description.

## Value

`.doc_err*()` return an entry for `.doc_errors()`. `.doc_errors()`
returns markdown.

## Details

Entries that share wording across many functions have their own helper
(for example, `.doc_err_null()`). Helpers for the `coerce` and
`incompatible_values` subclasses take the target class so the subclass
and text stay consistent. Use `.doc_err()` for one-off entries and
`.doc_err_other()` for entries that don't correspond to an stbl
subclass.
