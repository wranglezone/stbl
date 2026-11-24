# Format matched specification labels for an error message

When two or more matched labels are identical (e.g. the same function or
prototype passed more than once via `...`), appends each label's
position in `...` so the matches can be told apart; otherwise returns
`matched` unchanged, letting the caller quote it with
`{.val {matched}}`.

## Usage

``` r
.label_matched_specs(matched, matched_at)
```

## Arguments

- matched:

  `(character)` Labels of the specifications that succeeded.

- matched_at:

  `(integer)` Positions in `...` of the specifications that succeeded,
  parallel to `matched`.

## Value

A character vector, pre-quoted with position suffixes if `matched`
contains duplicates, or `matched` itself otherwise.
