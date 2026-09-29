# Signal an error when the match count falls outside min_matches/max_matches

Signal an error when the match count falls outside
min_matches/max_matches

## Usage

``` r
.check_match_count(
  matched_locations,
  min_matches,
  max_matches,
  x_arg,
  x_class,
  call
)
```

## Arguments

- matched_locations:

  `(integer)` Positions in `x` that matched `spec`.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- x_class:

  (`character(1)`) The class name of the object being stabilized to use
  in error messages. Use this if you remove a special class from the
  object before checking its coercion, but want the error message to
  match the original class.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if the match count is within bounds.
