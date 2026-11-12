# Identify the class, type, etc of an object

Extract the class (or type) of an object for use in error messages.

## Usage

``` r
object_type(x)
```

## Arguments

- x:

  An object to test.

## Value

A length-1 character vector describing the class of the object.

## Examples

``` r
object_type("a")
#> [1] "character"
object_type(1L)
#> [1] "integer"
object_type(1.1)
#> [1] "double"
object_type(mtcars)
#> [1] "data.frame"
object_type(rlang::quo(something))
#> [1] "quosure"
```
