# Copy names onto a converted object

Many base conversions drop names. Names are copied from `from` only when
`x` has none and the lengths match.

## Usage

``` r
.copy_names(x, from)
```

## Arguments

- x:

  The converted object.

- from:

  The object as supplied by the user.

## Value

`x`, with the names of `from` if they apply.
