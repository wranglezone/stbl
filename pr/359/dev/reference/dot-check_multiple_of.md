# Check that all elements are integer multiples of a value

Doubles are compared with a small relative tolerance
(`sqrt(.Machine$double.eps)`, the same default used by
[`base::all.equal()`](https://rdrr.io/r/base/all.equal.html)) so that
representable rounding error (e.g. `0.3 / 0.1`) doesn't produce spurious
failures.

## Usage

``` r
.check_multiple_of(x, multiple_of, x_arg = caller_arg(x), call = caller_env())
```

## Arguments

- x:

  The object to check.

- multiple_of:

  (`numeric(1)`, positive) The value `x` must be a multiple of. `NULL`
  skips the check.

- x_arg:

  (`character(1)`) The name of the object being stabilized to use in
  error messages. The automatic value will work in most cases, or pass
  it through from higher-level functions to make error messages clearer
  in unexported functions.

- call:

  `(environment)` The execution environment to mention as the source of
  error messages.

## Value

`NULL` invisibly (called for side effects).
