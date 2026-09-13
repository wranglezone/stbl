# An empty date object for error messages

[`object_type()`](https://stbl.wrangle.zone/dev/reference/object_type.md)
renders a [base::Date](https://rdrr.io/r/base/Dates.html) as `"Date"`,
but the date family uses the lowercase `"date"` in its coercion classes
and messages. This returns an empty object that renders as `"date"` so
error subclasses read `<stbl-error-incompatible_values-date>`.

## Usage

``` r
.date_type_obj()
```

## Value

A zero-length object whose
[`object_type()`](https://stbl.wrangle.zone/dev/reference/object_type.md)
is `"date"`.
