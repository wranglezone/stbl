# Call the C routine to convert a vector to another type

Call the C routine to convert a vector to another type

## Usage

``` r
.chr_are_fnish(x)

.chr_to_fn(x, definition_env = rlang::global_env())

.chr_to_lgl(x)

.chr_to_int(x)

.chr_to_dbl(x)

.chr_are_fctish(x, levels = NULL, to_na = character())

.dbl_to_chr(x)

.dbl_are_chrish(x)

.dbl_to_int(x)

.dbl_to_lgl(x)

.dbl_are_lglish(x)

.int_to_chr(x)

.int_are_chrish(x)

.int_to_fct(x, to = NULL, ordered = FALSE)

.int_to_dbl(x)

.int_are_dblish(x)

.lgl_to_chr(x)

.lgl_are_chrish(x)

.lgl_to_dbl(x)

.lgl_to_int(x)

.lgl_are_dblish(x)

.lgl_are_intish(x)

.cpx_to_dbl(x)

.cpx_to_int(x)

.fct_to_chr(x)

.fct_are_chrish(x)

.fct_to_dbl(x)

.fct_to_int(x)

.fct_to_lgl(x)

.fct_are_fctish(x, levels = NULL, to_na = character())

.lst_to_dbl(x)

.lst_to_int(x)

.lst_to_lgl(x)

.lst_to_chr(x)

.lst_to_fct(x)

.stbl_to(x, to)

.check_min_dbl(x, min_val)

.check_max_dbl(x, max_val)
```

## Arguments

- x:

  The argument to stabilize.

- levels:

  `(character)` The desired factor levels.

- to_na:

  `(character)` Values to convert to `NA`.

## Value

`.x_to_y()`: A list with two elements: `result`, the converted vector,
and `valid`, a logical vector indicating whether each element was
successfully coerced without losing information. `.x_are_yish()`: A
logical vector indicating whether each element of `x` can be coerced to
the target type. `.check_min_dbl()` and `.check_max_dbl()`: `NULL` if
all values pass the check, otherwise a vector of failing indices.
