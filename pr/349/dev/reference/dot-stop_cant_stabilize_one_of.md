# Signal an error when zero, or more than one, specs match in stabilize_one_of()/to_one_of()

Signal an error when zero, or more than one, specs match in
stabilize_one_of()/to_one_of()

## Usage

``` r
.stop_cant_stabilize_one_of(errors, matched, matched_at, x_arg, call)
```

## Arguments

- errors:

  `(list)` List of error conditions from failed attempts. Only used when
  `matched` is empty.

- matched:

  `(character)` Labels of the specifications that succeeded. Only used
  when there are two or more.

- matched_at:

  `(integer)` Positions in `...` of the specifications that succeeded,
  parallel to `matched`. Used to disambiguate `matched` labels that are
  identical (e.g. the same function passed more than once).

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

Does not return; throws an error.
