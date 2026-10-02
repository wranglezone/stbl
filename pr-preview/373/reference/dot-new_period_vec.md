# Build a vector of [lubridate::Period](https://lubridate.tidyverse.org/reference/Period-class.html) from component vectors

[`lubridate::period()`](https://lubridate.tidyverse.org/reference/period.html)
pairs a `num` vector elementwise against `units`, rather than building
one period per row, so it can't build a vector of independent periods
from parallel component vectors. This constructs the `Period` object
directly instead, which is vectorized over its slots.

## Usage

``` r
.new_period_vec(year, month, day, hour, minute, second)
```

## Arguments

- year, month, day, hour, minute, second:

  `(numeric)` Parallel vectors of period components, the same length.

## Value

A
[lubridate::Period](https://lubridate.tidyverse.org/reference/Period-class.html)
vector the same length as the inputs.
