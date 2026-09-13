# Coerce a condition object to a single character string

Coerce a condition object to a single character string

## Usage

``` r
# S3 method for class 'condition'
.to_chr_impl(
  x,
  ...,
  x_arg = caller_arg(x),
  call = caller_env(),
  x_class = object_type(x)
)
```

## Arguments

- x:

  (`condition`) A condition object.

## Value

A length-1 character string containing the full class hierarchy and
condition message.
