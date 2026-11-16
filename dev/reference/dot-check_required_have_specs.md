# Check that required names without specs are compatible with `.named`

A required name that has no spec can only be present if extra named
elements are allowed, so an explicit `FALSE` is an inconsistent call.

## Usage

``` r
.check_required_have_specs(required, spec_names, named, named_arg, call)
```

## Arguments

- required:

  A canonical requirements list.

- spec_names:

  `(character)` Names that have a spec.

- named:

  The extra-element control (`.named` or `.extra_cols`).

- named_arg:

  (`character(1)`) Name of the `named` argument.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL`, invisibly, if the check passes.
