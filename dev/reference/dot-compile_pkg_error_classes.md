# Compile an error class chain

Compile an error class chain

## Usage

``` r
.compile_pkg_error_classes(package, ...)
```

## Arguments

- package:

  `(length-1 character)` The name of the package to use in classes.

- ...:

  `(character)` Components of the class name, from least-specific to
  most.

## Value

A character vector of classes.
