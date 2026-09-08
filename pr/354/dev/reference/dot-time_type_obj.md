# An empty time object for error messages

[`object_type()`](https://stbl.wrangle.zone/dev/reference/object_type.md)
renders an [`hms::hms()`](https://hms.tidyverse.org/reference/hms.html)
as `"hms"`, but the time family uses `"time"` in its coercion classes
and messages, to match the
[`to_time()`](https://stbl.wrangle.zone/dev/reference/to_time.md)/[`stabilize_time()`](https://stbl.wrangle.zone/dev/reference/stabilize_time.md)
function names. This returns an empty object that renders as `"time"` so
error subclasses read `<stbl-error-incompatible_values-time>`.

## Usage

``` r
.time_type_obj()
```

## Value

A zero-length object whose
[`object_type()`](https://stbl.wrangle.zone/dev/reference/object_type.md)
is `"time"`.
