# Describe the location of an element within a list

Describe the location of an element within a list

## Usage

``` r
.path_step(nms, i, is_df = FALSE)
```

## Arguments

- nms:

  `(character)` The names of the list, or `NULL`.

- i:

  `(integer(1))` The position of the element.

- is_df:

  `(logical(1))` Whether the list is a data frame.

## Value

A string like `"$a"` or `"[[2]]"`.
