# An empty date-time object for error messages

[`object_type()`](https://stbl.wrangle.zone/dev/reference/object_type.md)
renders a [base::POSIXct](https://rdrr.io/r/base/DateTimeClasses.html)
as `"POSIXct"`, but the datetime family uses `"datetime"` in its
coercion classes and messages, to match the
[`to_dttm()`](https://stbl.wrangle.zone/dev/reference/to_dttm.md)/[`stabilize_dttm()`](https://stbl.wrangle.zone/dev/reference/stabilize_dttm.md)
function names. This returns an empty object that renders as
`"datetime"` so error subclasses read
`<stbl-error-incompatible_values-datetime>`.

## Usage

``` r
.datetime_type_obj()
```

## Value

A zero-length object whose
[`object_type()`](https://stbl.wrangle.zone/dev/reference/object_type.md)
is `"datetime"`.
