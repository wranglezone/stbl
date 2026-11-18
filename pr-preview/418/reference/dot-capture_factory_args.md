# Capture the non-missing arguments of the calling function

Used inside `specify_*()` functions to build the `factory_args` list
passed to
[`.specify_cls()`](https://stbl.wrangle.zone/dev/reference/dot-specify_cls.md),
keeping only the arguments that the caller of the `specify_*()` function
actually supplied (as opposed to those left at their default value).

## Usage

``` r
.capture_factory_args()
```

## Value

A named list of the values of arguments that weren't left missing in the
function that called `.capture_factory_args()`.
