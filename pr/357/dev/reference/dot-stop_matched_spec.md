# Signal an error when x matches a spec forbidden by assert_not()

Signal an error when x matches a spec forbidden by assert_not()

## Usage

``` r
.stop_matched_spec(spec_label, x_arg, call)
```

## Arguments

- spec_label:

  `(character(1))` A label for the spec that `x` matched, used in the
  error message.

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
