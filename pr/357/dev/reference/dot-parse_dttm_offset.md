# Convert an RFC 3339 time-offset to a number of seconds

Convert an RFC 3339 time-offset to a number of seconds

## Usage

``` r
.parse_dttm_offset(x)
```

## Arguments

- x:

  `(character)` Time-offset strings, each either `"Z"`/`"z"` or a
  numeric offset such as `"+05:00"` or `"-05:30"`.

## Value

A numeric vector of offsets from UTC, in seconds. Local time minus the
offset gives the UTC instant.
