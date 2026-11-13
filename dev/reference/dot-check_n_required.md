# Check that `.n_required` is a valid count of required positions

Check that `.n_required` is a valid count of required positions

## Usage

``` r
.check_n_required(.n_required, n_specs, call)
```

## Arguments

- .n_required:

  `(integer(1))` The number of leading positions that must be present in
  `.x`. Defaults to all of them. Must be between 0 and the number of
  specs. A zero-length `.x` (such as
  [`list()`](https://rdrr.io/r/base/list.html)) skips this check when
  `.allow_zero_length = TRUE`. This is independent of `.min_size` and
  `.max_size`, which check the total length.

- n_specs:

  `(integer(1))` The number of specs.

- call:

  `(environment)` The environment for errors.

## Value

`.n_required` as an integer.
