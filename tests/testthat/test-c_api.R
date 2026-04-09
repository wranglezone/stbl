test_that(".chr_to_lgl() converts TRUE/T strings to TRUE (#218)", {
  expect_identical(
    .chr_to_lgl(c("TRUE", "true", "T", "t")),
    c(TRUE, TRUE, TRUE, TRUE)
  )
})

test_that(".chr_to_lgl() converts FALSE/F strings to FALSE (#218)", {
  expect_identical(
    .chr_to_lgl(c("FALSE", "false", "F", "f")),
    c(FALSE, FALSE, FALSE, FALSE)
  )
})

test_that(".chr_to_lgl() passes NA through (#218)", {
  expect_identical(.chr_to_lgl(NA_character_), NA)
})

test_that(".chr_to_lgl() converts numeric strings (#218)", {
  expect_identical(
    .chr_to_lgl(c("0", "1", "-1", "1.5")),
    c(FALSE, TRUE, TRUE, TRUE)
  )
})

test_that(".chr_to_lgl() returns NA for invalid strings (#218)", {
  expect_identical(.chr_to_lgl(c("a", "", "NaN")), c(NA, NA, NA))
})

test_that(".chr_to_int() converts integer strings (#219)", {
  expect_identical(
    .chr_to_int(c("1", "2", "-3", "0")),
    c(1L, 2L, -3L, 0L)
  )
})

test_that(".chr_to_int() converts whole-number double strings (#219)", {
  expect_identical(
    .chr_to_int(c("1.0", "2.00", "-3.0")),
    c(1L, 2L, -3L)
  )
})

test_that(".chr_to_int() passes NA through (#219)", {
  expect_identical(.chr_to_int(NA_character_), NA_integer_)
})

test_that(".chr_to_int() returns NA for strings with fractional parts (#219)", {
  expect_identical(.chr_to_int(c("1.5", "2.9")), c(NA_integer_, NA_integer_))
})

test_that(".chr_to_int() returns NA for non-number strings (#219)", {
  expect_identical(
    .chr_to_int(c("a", "", "NaN")),
    c(NA_integer_, NA_integer_, NA_integer_)
  )
})

test_that(".chr_to_int() returns NA for Inf strings (#219)", {
  expect_identical(.chr_to_int(c("Inf", "-Inf")), c(NA_integer_, NA_integer_))
})

test_that(".chr_to_dbl() converts numeric strings (#221)", {
  expect_identical(
    .chr_to_dbl(c("1.5", "2.0", "-3.14")),
    c(1.5, 2.0, -3.14)
  )
})

test_that(".chr_to_dbl() converts Inf strings (#221)", {
  expect_identical(
    .chr_to_dbl(c("Inf", "-Inf")),
    c(Inf, -Inf)
  )
})

test_that(".chr_to_dbl() passes NA through (#221)", {
  expect_identical(.chr_to_dbl(NA_character_), NA_real_)
})

test_that(".chr_to_dbl() returns NA for invalid strings (#221)", {
  expect_identical(
    .chr_to_dbl(c("a", "", "NaN")),
    c(NA_real_, NA_real_, NA_real_)
  )
})

test_that(".dbl_to_int() converts integer-valued doubles (#217)", {
  expect_identical(
    .dbl_to_int(c(1.0, 2.0, -3.0, 0.0)),
    c(1L, 2L, -3L, 0L)
  )
})

test_that(".dbl_to_int() passes NA and NaN through (#217)", {
  expect_identical(.dbl_to_int(NA_real_), NA_integer_)
  expect_identical(.dbl_to_int(NaN), NA_integer_)
})

test_that(".dbl_to_int() returns NA for fractional doubles (#217)", {
  expect_identical(.dbl_to_int(c(1.5, 2.9)), c(NA_integer_, NA_integer_))
})

test_that(".dbl_to_int() returns NA for Inf and out-of-range values (#217)", {
  expect_identical(.dbl_to_int(c(Inf, -Inf)), c(NA_integer_, NA_integer_))
  expect_identical(.dbl_to_int(2147483648), NA_integer_)
})

# int -> dbl --------------------------------------------------------------- ----

test_that(".int_to_dbl() converts integers to doubles (#226)", {
  expect_identical(.int_to_dbl(c(1L, 2L, -3L, 0L)), c(1.0, 2.0, -3.0, 0.0))
})

test_that(".int_to_dbl() passes NA through (#226)", {
  expect_identical(.int_to_dbl(NA_integer_), NA_real_)
})

# lgl -> dbl --------------------------------------------------------------- ----

test_that(".lgl_to_dbl() converts TRUE to 1.0 (#226)", {
  expect_identical(.lgl_to_dbl(TRUE), 1.0)
})

test_that(".lgl_to_dbl() converts FALSE to 0.0 (#226)", {
  expect_identical(.lgl_to_dbl(FALSE), 0.0)
})

test_that(".lgl_to_dbl() passes NA through (#226)", {
  expect_identical(.lgl_to_dbl(NA), NA_real_)
})

# lgl -> int --------------------------------------------------------------- ----

test_that(".lgl_to_int() converts TRUE to 1L (#226)", {
  expect_identical(.lgl_to_int(TRUE), 1L)
})

test_that(".lgl_to_int() converts FALSE to 0L (#226)", {
  expect_identical(.lgl_to_int(FALSE), 0L)
})

test_that(".lgl_to_int() passes NA through (#226)", {
  expect_identical(.lgl_to_int(NA), NA_integer_)
})

# dbl -> lgl --------------------------------------------------------------- ----

test_that(".dbl_to_lgl() converts 0 to FALSE (#226)", {
  expect_identical(.dbl_to_lgl(0.0), FALSE)
})

test_that(".dbl_to_lgl() converts non-zero to TRUE (#226)", {
  expect_identical(.dbl_to_lgl(c(1.0, -1.0, 1.5)), c(TRUE, TRUE, TRUE))
})

test_that(".dbl_to_lgl() passes NA and NaN through as NA (#226)", {
  expect_identical(.dbl_to_lgl(NA_real_), NA)
  expect_identical(.dbl_to_lgl(NaN), NA)
})

test_that(".dbl_to_lgl() handles integer input (#226)", {
  expect_identical(.dbl_to_lgl(0L), FALSE)
  expect_identical(.dbl_to_lgl(1L), TRUE)
  expect_identical(.dbl_to_lgl(NA_integer_), NA)
})

# cpx -> dbl --------------------------------------------------------------- ----

test_that(".cpx_to_dbl() extracts real part when Im is zero (#226)", {
  expect_identical(.cpx_to_dbl(c(1 + 0i, -2 + 0i)), c(1.0, -2.0))
})

test_that(".cpx_to_dbl() passes NA complex through as NA_real (#226)", {
  expect_identical(.cpx_to_dbl(NA_complex_), NA_real_)
})

test_that(".cpx_to_dbl() returns real part for non-zero Im (no error) (#226)", {
  expect_identical(.cpx_to_dbl(1 + 2i), 1.0)
})

# cpx -> int --------------------------------------------------------------- ----

test_that(".cpx_to_int() converts whole-number complex with Im 0 (#226)", {
  expect_identical(.cpx_to_int(c(1 + 0i, -3 + 0i)), c(1L, -3L))
})

test_that(".cpx_to_int() passes NA complex through as NA_integer (#226)", {
  expect_identical(.cpx_to_int(NA_complex_), NA_integer_)
})

test_that(".cpx_to_int() returns NA for non-zero Im (#226)", {
  expect_identical(.cpx_to_int(1 + 2i), NA_integer_)
})

test_that(".cpx_to_int() returns NA for fractional real part (#226)", {
  expect_identical(.cpx_to_int(1.5 + 0i), NA_integer_)
})

# fct -> dbl --------------------------------------------------------------- ----

test_that(".fct_to_dbl() converts numeric factor levels to doubles (#226)", {
  expect_identical(
    .fct_to_dbl(factor(c("1.5", "2.0", "3.14"))),
    c(1.5, 2.0, 3.14)
  )
})

test_that(".fct_to_dbl() passes NA factor element through (#226)", {
  f <- factor(c("1.0", NA))
  expect_identical(.fct_to_dbl(f), c(1.0, NA_real_))
})

test_that(".fct_to_dbl() returns NA for non-numeric levels (#226)", {
  expect_identical(.fct_to_dbl(factor(c("a", "1.0"))), c(NA_real_, 1.0))
})

# fct -> int --------------------------------------------------------------- ----

test_that(".fct_to_int() converts whole-number factor levels to integers (#226)", {
  expect_identical(
    .fct_to_int(factor(c("1", "2", "-3"))),
    c(1L, 2L, -3L)
  )
})

test_that(".fct_to_int() passes NA factor element through (#226)", {
  f <- factor(c("1", NA))
  expect_identical(.fct_to_int(f), c(1L, NA_integer_))
})

test_that(".fct_to_int() returns NA for non-integer levels (#226)", {
  expect_identical(
    .fct_to_int(factor(c("a", "1.5"))),
    c(NA_integer_, NA_integer_)
  )
})

# fct -> lgl --------------------------------------------------------------- ----

test_that(".fct_to_lgl() converts TRUE/FALSE levels (#226)", {
  expect_identical(
    .fct_to_lgl(factor(c("TRUE", "FALSE", "T", "F"))),
    c(TRUE, FALSE, TRUE, FALSE)
  )
})

test_that(".fct_to_lgl() passes NA factor element through (#226)", {
  f <- factor(c("TRUE", NA))
  expect_identical(.fct_to_lgl(f), c(TRUE, NA))
})

test_that(".fct_to_lgl() returns NA for non-logical levels (#226)", {
  expect_identical(.fct_to_lgl(factor(c("a", "TRUE"))), c(NA, TRUE))
})

# chr -> fct (are_fctish) -------------------------------------------------- ----

test_that(".chr_are_fctish() returns all TRUE when levels is NULL (#226)", {
  expect_identical(
    .chr_are_fctish(c("a", "b", NA)),
    c(TRUE, TRUE, TRUE)
  )
})

test_that(".chr_are_fctish() checks membership in levels (#226)", {
  expect_identical(
    .chr_are_fctish(c("a", "b", "c"), levels = c("a", "b")),
    c(TRUE, TRUE, FALSE)
  )
})

test_that(".chr_are_fctish() treats NA as fctish regardless of levels (#226)", {
  expect_identical(
    .chr_are_fctish(NA_character_, levels = c("a", "b")),
    TRUE
  )
})

test_that(".chr_are_fctish() treats to_na values as fctish (#226)", {
  expect_identical(
    .chr_are_fctish(c("a", "z"), levels = c("a", "b"), to_na = "z"),
    c(TRUE, TRUE)
  )
})

# fct -> fct (are_fctish) -------------------------------------------------- ----

test_that(".fct_are_fctish() returns all TRUE when levels is NULL (#226)", {
  expect_identical(
    .fct_are_fctish(factor(c("a", "b"))),
    c(TRUE, TRUE)
  )
})

test_that(".fct_are_fctish() checks factor level membership in target levels (#226)", {
  f <- factor(c("a", "b", "c"))
  expect_identical(
    .fct_are_fctish(f, levels = c("a", "b")),
    c(TRUE, TRUE, FALSE)
  )
})

test_that(".fct_are_fctish() treats NA as fctish regardless of levels (#226)", {
  f <- factor(c("a", NA))
  expect_identical(
    .fct_are_fctish(f, levels = c("a", "b")),
    c(TRUE, TRUE)
  )
})

# lst -> dbl --------------------------------------------------------------- ----

test_that(".lst_to_dbl() converts a flat list of numeric scalars (#226)", {
  expect_identical(.lst_to_dbl(list(1.0, 2L, TRUE)), c(1.0, 2.0, 1.0))
})

test_that(".lst_to_dbl() passes NA through (#226)", {
  expect_identical(.lst_to_dbl(list(NA_real_)), NA_real_)
})

test_that(".lst_to_dbl() returns NULL for non-scalar elements (#226)", {
  expect_null(.lst_to_dbl(list(c(1.0, 2.0))))
})

test_that(".lst_to_dbl() returns NULL for unsupported types (#226)", {
  expect_null(.lst_to_dbl(list("a")))
})

# lst -> int --------------------------------------------------------------- ----

test_that(".lst_to_int() converts a flat list of integer/logical scalars (#226)", {
  expect_identical(.lst_to_int(list(1L, FALSE, TRUE)), c(1L, 0L, 1L))
})

test_that(".lst_to_int() converts whole-number doubles (#226)", {
  expect_identical(.lst_to_int(list(1.0, 2.0)), c(1L, 2L))
})

test_that(".lst_to_int() passes NA through (#226)", {
  expect_identical(.lst_to_int(list(NA_integer_)), NA_integer_)
})

test_that(".lst_to_int() returns NULL for fractional doubles (#226)", {
  expect_null(.lst_to_int(list(1.5)))
})

test_that(".lst_to_int() returns NULL for non-scalar elements (#226)", {
  expect_null(.lst_to_int(list(c(1L, 2L))))
})

# lst -> lgl --------------------------------------------------------------- ----

test_that(".lst_to_lgl() converts a flat list of lgl/int/dbl scalars (#226)", {
  expect_identical(.lst_to_lgl(list(TRUE, 0L, 1.0)), c(TRUE, FALSE, TRUE))
})

test_that(".lst_to_lgl() passes NA through (#226)", {
  expect_identical(.lst_to_lgl(list(NA)), NA)
})

test_that(".lst_to_lgl() returns NULL for non-scalar elements (#226)", {
  expect_null(.lst_to_lgl(list(c(TRUE, FALSE))))
})

test_that(".lst_to_lgl() returns NULL for unsupported types (#226)", {
  expect_null(.lst_to_lgl(list("a")))
})

# lst -> chr --------------------------------------------------------------- ----

test_that(".lst_to_chr() converts a flat list of character scalars (#226)", {
  expect_identical(
    .lst_to_chr(list("a", "b", NA_character_)),
    c("a", "b", NA_character_)
  )
})

test_that(".lst_to_chr() returns NULL for non-character elements (#226)", {
  expect_null(.lst_to_chr(list(1L)))
})

test_that(".lst_to_chr() returns NULL for non-scalar elements (#226)", {
  expect_null(.lst_to_chr(list(c("a", "b"))))
})

# lst -> fct --------------------------------------------------------------- ----

test_that(".lst_to_fct() converts a flat list of character scalars (#226)", {
  expect_identical(
    .lst_to_fct(list("a", "b", NA_character_)),
    c("a", "b", NA_character_)
  )
})

test_that(".lst_to_fct() returns NULL for non-character elements (#226)", {
  expect_null(.lst_to_fct(list(1L)))
})

test_that(".lst_to_fct() returns NULL for non-scalar elements (#226)", {
  expect_null(.lst_to_fct(list(c("a", "b"))))
})

# range checks ------------------------------------------------------------- ----

test_that(".check_min_dbl() returns NULL when all values pass (#220)", {
  expect_null(.check_min_dbl(c(1.0, 2.0, 3.0), 1.0))
  expect_null(.check_min_dbl(double(0), 0.0))
})

test_that(".check_min_dbl() returns failure indices for values below min (#220)", {
  expect_identical(.check_min_dbl(c(1.0, 2.0, 3.0), 2.0), 1L)
  expect_identical(.check_min_dbl(c(0.0, 1.0, 2.0, 3.0), 2.0), c(1L, 2L))
})

test_that(".check_min_dbl() treats NA as passing (#220)", {
  expect_null(.check_min_dbl(c(NA_real_, 2.0), 1.0))
  expect_identical(.check_min_dbl(c(NA_real_, 0.5), 1.0), 2L)
})

test_that(".check_min_dbl() handles integer input (#220)", {
  expect_null(.check_min_dbl(c(2L, 3L), 1.0))
  expect_identical(.check_min_dbl(c(1L, 2L, 3L), 2.0), 1L)
  expect_null(.check_min_dbl(c(NA_integer_, 2L), 1.0))
})

test_that(".check_max_dbl() returns NULL when all values pass (#220)", {
  expect_null(.check_max_dbl(c(1.0, 2.0, 3.0), 3.0))
  expect_null(.check_max_dbl(double(0), 0.0))
})

test_that(".check_max_dbl() returns failure indices for values above max (#220)", {
  expect_identical(.check_max_dbl(c(1.0, 2.0, 3.0), 2.0), 3L)
  expect_identical(.check_max_dbl(c(1.0, 2.0, 3.0, 4.0), 2.0), c(3L, 4L))
})

test_that(".check_max_dbl() treats NA as passing (#220)", {
  expect_null(.check_max_dbl(c(NA_real_, 1.0), 2.0))
  expect_identical(.check_max_dbl(c(NA_real_, 3.0), 2.0), 2L)
})

test_that(".check_max_dbl() handles integer input (#220)", {
  expect_null(.check_max_dbl(c(1L, 2L), 3.0))
  expect_identical(.check_max_dbl(c(1L, 2L, 3L), 2.0), 3L)
  expect_null(.check_max_dbl(c(NA_integer_, 1L), 2.0))
})
