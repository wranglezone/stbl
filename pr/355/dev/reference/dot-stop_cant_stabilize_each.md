# Signal a combined error when any element fails its spec

Signal a combined error when any element fails its spec

## Usage

``` r
.stop_cant_stabilize_each(errors, locations, x_arg, x_class, call)
```

## Arguments

- errors:

  `(list)` Error conditions for each failing location, in the same order
  as `locations`.

- locations:

  `(integer)` Positions in `x` that failed.

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

Does not return; throws an error.
