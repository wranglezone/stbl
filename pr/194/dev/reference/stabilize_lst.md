# Ensure a list argument meets expectations

`stabilize_lst()` validates the structure and contents of a list. It can
check that specific named elements are present and valid, that unnamed
elements conform to a shared rule, and that extra named elements conform
to a shared rule. `stabilise_lst()`, `stabilize_list()`, and
`stabilise_list()` are synonyms of `stabilize_lst()`.

## Usage

``` r
stabilize_lst(
  x,
  ...,
  .named = NULL,
  .unnamed = NULL,
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .x_arg = caller_arg(x),
  .call = caller_env(),
  .x_class = object_type(x),
  .element_specs = NULL
)

stabilize_list(
  x,
  ...,
  .named = NULL,
  .unnamed = NULL,
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .x_arg = caller_arg(x),
  .call = caller_env(),
  .x_class = object_type(x),
  .element_specs = NULL
)

stabilise_lst(
  x,
  ...,
  .named = NULL,
  .unnamed = NULL,
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .x_arg = caller_arg(x),
  .call = caller_env(),
  .x_class = object_type(x),
  .element_specs = NULL
)

stabilise_list(
  x,
  ...,
  .named = NULL,
  .unnamed = NULL,
  .allow_null = TRUE,
  .min_size = NULL,
  .max_size = NULL,
  .x_arg = caller_arg(x),
  .call = caller_env(),
  .x_class = object_type(x),
  .element_specs = NULL
)
```

## Arguments

- x:

  The list to validate.

- ...:

  Named
  [`specify_*()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md)
  functions for required named elements of `x`. Each name corresponds to
  a required element in `x`, and the function is used to validate that
  element.

- .named:

  A single
  [`specify_*()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md)
  function to validate all named elements of `x` that are *not*
  explicitly listed in `...`. If `NULL` (default), any extra named
  elements will cause an error.

- .unnamed:

  A single
  [`specify_*()`](https://stbl.wrangle.zone/dev/reference/specify_chr.md)
  function to validate all unnamed elements of `x`. If `NULL` (default),
  any unnamed elements will cause an error.

- .allow_null:

  `(length-1 logical)` Is `NULL` an acceptable value? Defaults to
  `TRUE`.

- .min_size:

  `(length-1 integer)` The minimum size of the list. Tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- .max_size:

  `(length-1 integer)` The maximum size of the list. Tested using
  [`vctrs::vec_size()`](https://vctrs.r-lib.org/reference/vec_size.html).

- .x_arg:

  `(length-1 character)` An argument name for `x`. The automatic value
  will work in most cases, or pass it through from higher-level
  functions to make error messages clearer in unexported functions.

- .call:

  `(environment)` The execution environment to mention as the source of
  error messages.

- .x_class:

  `(length-1 character)` The class name of `x` to use in error messages.
  Use this if you remove a special class from `x` before checking its
  coercion, but want the error message to match the original class.

- .element_specs:

  `(named list)` For internal use by
  [`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md).
  A named list of element specification functions that is merged with
  the specifications provided via `...`.

## Value

The validated list.

## See also

Other list functions:
[`specify_lst()`](https://stbl.wrangle.zone/dev/reference/specify_lst.md)

Other stabilization functions:
[`stabilize_arg()`](https://stbl.wrangle.zone/dev/reference/stabilize_arg.md),
[`stabilize_chr()`](https://stbl.wrangle.zone/dev/reference/stabilize_chr.md),
[`stabilize_dbl()`](https://stbl.wrangle.zone/dev/reference/stabilize_dbl.md),
[`stabilize_fct()`](https://stbl.wrangle.zone/dev/reference/stabilize_fct.md),
[`stabilize_int()`](https://stbl.wrangle.zone/dev/reference/stabilize_int.md),
[`stabilize_lgl()`](https://stbl.wrangle.zone/dev/reference/stabilize_lgl.md)

## Examples

``` r
# Basic validation: named required elements
stabilize_lst(
  list(name = "Alice", age = 30L),
  name = specify_chr_scalar(),
  age = specify_int_scalar()
)
#> $name
#> [1] "Alice"
#> 
#> $age
#> [1] 30
#> 

# Allow any non-NULL element with specify_present()
stabilize_lst(list(data = mtcars), data = specify_present())
#> $data
#>                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
#> Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
#> Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
#> Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
#> Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
#> Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
#> Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
#> AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
#> Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
#> Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
#> Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
#> 

# Allow extra named elements via .named
stabilize_lst(
  list(a = 1L, b = 2L, c = 3L),
  .named = specify_int_scalar()
)
#> $a
#> [1] 1
#> 
#> $b
#> [1] 2
#> 
#> $c
#> [1] 3
#> 

# Allow unnamed elements via .unnamed
stabilize_lst(list(1L, 2L, 3L), .unnamed = specify_int_scalar())
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 2
#> 
#> [[3]]
#> [1] 3
#> 

# NULL is allowed by default
stabilize_lst(NULL)
#> NULL
try(stabilize_lst(NULL, .allow_null = FALSE))
#> Error in eval(expr, envir) : `NULL` must not be <NULL>.

# Enforce size constraints
try(stabilize_lst(list(a = 1L), .min_size = 2))
#> Error in eval(expr, envir) : `list(a = 1L)` must have size >= 2.
#> ✖ 1 is too small.
```
