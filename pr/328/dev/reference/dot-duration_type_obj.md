# An empty duration object for error messages

[`object_type()`](https://stbl.wrangle.zone/dev/reference/object_type.md)
renders a
[lubridate::Period](https://lubridate.tidyverse.org/reference/Period-class.html)
as `"Period"`, but the duration family uses `"duration"` in its coercion
classes and messages, to match the
[`to_dur()`](https://stbl.wrangle.zone/dev/reference/to_dur.md)/[`stabilize_dur()`](https://stbl.wrangle.zone/dev/reference/stabilize_dur.md)
function names. This returns an empty object that renders as
`"duration"` so error subclasses read
`<stbl-error-incompatible_values-duration>`.

## Usage

``` r
.duration_type_obj()
```

## Value

A zero-length object whose
[`object_type()`](https://stbl.wrangle.zone/dev/reference/object_type.md)
is `"duration"`.
