# Convert a strptime()-style format string to a field-capturing regex

Unlike
[`.format_to_regex()`](https://stbl.wrangle.zone/dev/reference/dot-format_to_regex.md),
this keeps track of which calendar field each capture group corresponds
to, so the captured digits can be reassembled regardless of the order in
which the format places them (for example `"%m/%d/%Y"` vs.
`"%Y-%m-%d"`).

## Usage

``` r
.format_to_capture_regex(fmt)
```

## Arguments

- fmt:

  (`character(1)`) A
  [`strptime()`](https://rdrr.io/r/base/strptime.html)-style format
  string built from `%Y`, `%m`, `%d`, `%H`, `%M`, and `%S` specifiers
  and literal separators.

## Value

A list with:

- `regex`: the unanchored regex body (not yet wrapped in `^`/`$`).

- `fields`: a character vector naming the calendar field (one of `"Y"`,
  `"m"`, `"d"`, `"H"`, `"M"`, or `"S"`) captured by each group, in the
  order the groups appear in `regex`.
