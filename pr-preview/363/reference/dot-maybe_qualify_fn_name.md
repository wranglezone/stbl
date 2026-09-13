# Return a package-qualified name if the name resolves to the same function

Return a package-qualified name if the name resolves to the same
function

## Usage

``` r
.maybe_qualify_fn_name(fn, fn_env, x_name)
```

## Arguments

- fn:

  The function.

- fn_env:

  The namespace environment of `fn`.

- x_name:

  The name used to refer to `fn` at the call site.

## Value

`"pkg::x_name"` if `x_name` resolves to `fn` in `fn_env`, otherwise
`x_name`.
