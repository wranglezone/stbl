# chr -> lgl -------------------------------------------------------------------

test_that(".chr_to_lgl() converts TRUE/T strings to TRUE (#218, #237)", {
  res <- .chr_to_lgl(c("TRUE", "true", "T", "t"))
  expect_identical(res[["result"]], c(TRUE, TRUE, TRUE, TRUE))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE, TRUE))
})

test_that(".chr_to_lgl() converts FALSE/F strings to FALSE (#218, #237)", {
  res <- .chr_to_lgl(c("FALSE", "false", "F", "f"))
  expect_identical(res[["result"]], c(FALSE, FALSE, FALSE, FALSE))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE, TRUE))
})

test_that(".chr_to_lgl() passes NA through as valid (#218, #237)", {
  res <- .chr_to_lgl(NA_character_)
  expect_identical(res[["result"]], NA)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".chr_to_lgl() converts numeric strings (#218, #237)", {
  res <- .chr_to_lgl(c("0", "1", "-1", "1.5"))
  expect_identical(res[["result"]], c(FALSE, TRUE, TRUE, TRUE))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE, TRUE))
})

test_that(".chr_to_lgl() marks invalid strings as not valid (#218, #237)", {
  res <- .chr_to_lgl(c("a", "", "NaN"))
  expect_identical(res[["result"]], c(NA, NA, NA))
  expect_identical(res[["valid"]], c(FALSE, FALSE, FALSE))
})

# chr -> int -------------------------------------------------------------------

test_that(".chr_to_int() converts integer strings (#219, #237)", {
  res <- .chr_to_int(c("1", "2", "-3", "0"))
  expect_identical(res[["result"]], c(1L, 2L, -3L, 0L))
  expect_false(any(res[["non_number"]]))
  expect_false(any(res[["bad_precision"]]))
})

test_that(".chr_to_int() converts whole-number double strings (#219, #237)", {
  res <- .chr_to_int(c("1.0", "2.00", "-3.0"))
  expect_identical(res[["result"]], c(1L, 2L, -3L))
})

test_that(".chr_to_int() passes NA through (#219, #237)", {
  res <- .chr_to_int(NA_character_)
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["non_number"]], FALSE)
  expect_identical(res[["bad_precision"]], FALSE)
})

test_that(".chr_to_int() marks fractional strings as bad_precision (#219, #237)", {
  res <- .chr_to_int(c("1.5", "2.9"))
  expect_identical(res[["result"]], c(NA_integer_, NA_integer_))
  expect_identical(res[["bad_precision"]], c(TRUE, TRUE))
  expect_false(any(res[["non_number"]]))
})

test_that(".chr_to_int() marks non-number strings as non_number (#219, #237)", {
  res <- .chr_to_int(c("a", "", "NaN"))
  expect_identical(res[["result"]], c(NA_integer_, NA_integer_, NA_integer_))
  expect_identical(res[["non_number"]], c(TRUE, TRUE, TRUE))
})

test_that(".chr_to_int() marks Inf strings as bad_precision (#219, #237)", {
  res <- .chr_to_int(c("Inf", "-Inf"))
  expect_identical(res[["result"]], c(NA_integer_, NA_integer_))
  expect_identical(res[["bad_precision"]], c(TRUE, TRUE))
})

# chr -> dbl -------------------------------------------------------------------

test_that(".chr_to_dbl() converts numeric strings (#221, #237)", {
  res <- .chr_to_dbl(c("1.5", "2.0", "-3.14"))
  expect_identical(res[["result"]], c(1.5, 2.0, -3.14))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".chr_to_dbl() converts Inf strings (#221, #237)", {
  res <- .chr_to_dbl(c("Inf", "-Inf"))
  expect_identical(res[["result"]], c(Inf, -Inf))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".chr_to_dbl() passes NA through as valid (#221, #237)", {
  res <- .chr_to_dbl(NA_character_)
  expect_identical(res[["result"]], NA_real_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".chr_to_dbl() marks invalid strings as not valid (#221, #237)", {
  res <- .chr_to_dbl(c("a", "", "NaN"))
  expect_identical(res[["result"]], c(NA_real_, NA_real_, NA_real_))
  expect_identical(res[["valid"]], c(FALSE, FALSE, FALSE))
})

# dbl -> int -------------------------------------------------------------------

test_that(".dbl_to_int() converts integer-valued doubles (#217, #237)", {
  res <- .dbl_to_int(c(1.0, 2.0, -3.0, 0.0))
  expect_identical(res[["result"]], c(1L, 2L, -3L, 0L))
  expect_false(any(res[["bad_precision"]]))
})

test_that(".dbl_to_int() passes NA and NaN through as not bad_precision (#217, #237)", {
  res_na <- .dbl_to_int(NA_real_)
  res_nan <- .dbl_to_int(NaN)
  expect_identical(res_na[["result"]], NA_integer_)
  expect_identical(res_na[["bad_precision"]], FALSE)
  expect_identical(res_nan[["result"]], NA_integer_)
  expect_identical(res_nan[["bad_precision"]], FALSE)
})

test_that(".dbl_to_int() marks fractional doubles as bad_precision (#217, #237)", {
  res <- .dbl_to_int(c(1.5, 2.9))
  expect_identical(res[["result"]], c(NA_integer_, NA_integer_))
  expect_identical(res[["bad_precision"]], c(TRUE, TRUE))
})

test_that(".dbl_to_int() marks Inf and out-of-range values as bad_precision (#217, #237)", {
  res_inf <- .dbl_to_int(c(Inf, -Inf))
  res_range <- .dbl_to_int(2147483648)
  expect_identical(res_inf[["bad_precision"]], c(TRUE, TRUE))
  expect_identical(res_range[["bad_precision"]], TRUE)
})

# dbl -> lgl -------------------------------------------------------------------

test_that(".dbl_to_lgl() converts 0 to FALSE with valid TRUE (#226, #237)", {
  res <- .dbl_to_lgl(0.0)
  expect_identical(res[["result"]], FALSE)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".dbl_to_lgl() converts non-zero to TRUE with valid TRUE (#226, #237)", {
  res <- .dbl_to_lgl(c(1.0, -1.0, 1.5))
  expect_identical(res[["result"]], c(TRUE, TRUE, TRUE))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".dbl_to_lgl() passes NA and NaN through; valid always TRUE (#226, #237)", {
  res_na <- .dbl_to_lgl(NA_real_)
  res_nan <- .dbl_to_lgl(NaN)
  expect_identical(res_na[["result"]], NA)
  expect_identical(res_na[["valid"]], TRUE)
  expect_identical(res_nan[["result"]], NA)
  expect_identical(res_nan[["valid"]], TRUE)
})

test_that(".dbl_to_lgl() handles integer input; valid always TRUE (#226, #237)", {
  res_zero <- .dbl_to_lgl(0L)
  res_one <- .dbl_to_lgl(1L)
  res_na <- .dbl_to_lgl(NA_integer_)
  expect_identical(res_zero[["result"]], FALSE)
  expect_identical(res_one[["result"]], TRUE)
  expect_identical(res_na[["result"]], NA)
  expect_true(all(res_zero[["valid"]]))
  expect_true(all(res_one[["valid"]]))
  expect_true(all(res_na[["valid"]]))
})

test_that(".dbl_are_lglish() returns all TRUE (#218, #237)", {
  expect_identical(.dbl_are_lglish(c(0.0, 1.0, NA_real_, NaN)), rep(TRUE, 4))
})

# int -> dbl -------------------------------------------------------------------

test_that(".int_to_dbl() converts integers to doubles; valid always TRUE (#226, #237)", {
  res <- .int_to_dbl(c(1L, 2L, -3L, 0L))
  expect_identical(res[["result"]], c(1.0, 2.0, -3.0, 0.0))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE, TRUE))
})

test_that(".int_to_dbl() passes NA through; valid TRUE (#226, #237)", {
  res <- .int_to_dbl(NA_integer_)
  expect_identical(res[["result"]], NA_real_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".int_are_dblish() returns all TRUE (#226, #237)", {
  expect_identical(.int_are_dblish(c(1L, NA_integer_, 0L)), rep(TRUE, 3))
})

# lgl -> dbl -------------------------------------------------------------------

test_that(".lgl_to_dbl() converts TRUE to 1.0; valid TRUE (#226, #237)", {
  res <- .lgl_to_dbl(TRUE)
  expect_identical(res[["result"]], 1.0)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lgl_to_dbl() converts FALSE to 0.0; valid TRUE (#226, #237)", {
  res <- .lgl_to_dbl(FALSE)
  expect_identical(res[["result"]], 0.0)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lgl_to_dbl() passes NA through; valid TRUE (#226, #237)", {
  res <- .lgl_to_dbl(NA)
  expect_identical(res[["result"]], NA_real_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lgl_are_dblish() returns all TRUE (#226, #237)", {
  expect_identical(.lgl_are_dblish(c(TRUE, FALSE, NA)), rep(TRUE, 3))
})

# lgl -> int -------------------------------------------------------------------

test_that(".lgl_to_int() converts TRUE to 1L; valid TRUE (#226, #237)", {
  res <- .lgl_to_int(TRUE)
  expect_identical(res[["result"]], 1L)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lgl_to_int() converts FALSE to 0L; valid TRUE (#226, #237)", {
  res <- .lgl_to_int(FALSE)
  expect_identical(res[["result"]], 0L)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lgl_to_int() passes NA through; valid TRUE (#226, #237)", {
  res <- .lgl_to_int(NA)
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lgl_are_intish() returns all TRUE (#237)", {
  expect_identical(.lgl_are_intish(c(TRUE, FALSE, NA)), rep(TRUE, 3))
})

# cpx -> dbl -------------------------------------------------------------------

test_that(".cpx_to_dbl() extracts real part when Im is zero (#226, #237)", {
  res <- .cpx_to_dbl(c(1 + 0i, -2 + 0i))
  expect_identical(res[["result"]], c(1.0, -2.0))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".cpx_to_dbl() passes NA complex through as NA_real; valid TRUE (#226, #237)", {
  res <- .cpx_to_dbl(NA_complex_)
  expect_identical(res[["result"]], NA_real_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".cpx_to_dbl() returns real part and valid FALSE for non-zero Im (#226, #237)", {
  res <- .cpx_to_dbl(1 + 2i)
  expect_identical(res[["result"]], 1.0)
  expect_identical(res[["valid"]], FALSE)
})

# cpx -> int -------------------------------------------------------------------

test_that(".cpx_to_int() converts whole-number complex with Im 0 (#226, #237)", {
  res <- .cpx_to_int(c(1 + 0i, -3 + 0i))
  expect_identical(res[["result"]], c(1L, -3L))
  expect_false(any(res[["non_number"]]))
  expect_false(any(res[["bad_precision"]]))
})

test_that(".cpx_to_int() passes NA complex through; flags FALSE (#226, #237)", {
  res <- .cpx_to_int(NA_complex_)
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["non_number"]], FALSE)
  expect_identical(res[["bad_precision"]], FALSE)
})

test_that(".cpx_to_int() marks non-zero Im as non_number (#226, #237)", {
  res <- .cpx_to_int(1 + 2i)
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["non_number"]], TRUE)
})

test_that(".cpx_to_int() marks fractional real part as bad_precision (#226, #237)", {
  res <- .cpx_to_int(1.5 + 0i)
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["bad_precision"]], TRUE)
})

# fct -> dbl -------------------------------------------------------------------

test_that(".fct_to_dbl() converts numeric factor levels to doubles (#226, #237)", {
  res <- .fct_to_dbl(factor(c("1.5", "2.0", "3.14")))
  expect_identical(res[["result"]], c(1.5, 2.0, 3.14))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".fct_to_dbl() passes NA factor element through; valid TRUE (#226, #237)", {
  res <- .fct_to_dbl(factor(c("1.0", NA)))
  expect_identical(res[["result"]], c(1.0, NA_real_))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".fct_to_dbl() marks non-numeric levels as not valid (#226, #237)", {
  res <- .fct_to_dbl(factor(c("a", "1.0")))
  expect_identical(res[["result"]], c(NA_real_, 1.0))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})

# fct -> int -------------------------------------------------------------------

test_that(".fct_to_int() converts whole-number factor levels to integers (#226, #237)", {
  res <- .fct_to_int(factor(c("1", "2", "-3")))
  expect_identical(res[["result"]], c(1L, 2L, -3L))
  expect_false(any(res[["non_number"]]))
  expect_false(any(res[["bad_precision"]]))
})

test_that(".fct_to_int() passes NA factor element through; flags FALSE (#226, #237)", {
  res <- .fct_to_int(factor(c("1", NA)))
  expect_identical(res[["result"]], c(1L, NA_integer_))
  expect_identical(res[["non_number"]], c(FALSE, FALSE))
  expect_identical(res[["bad_precision"]], c(FALSE, FALSE))
})

test_that(".fct_to_int() marks non-integer levels correctly (#226, #237)", {
  res <- .fct_to_int(factor(c("a", "1.5")))
  expect_identical(res[["result"]], c(NA_integer_, NA_integer_))
  expect_identical(res[["non_number"]], c(TRUE, FALSE))
  expect_identical(res[["bad_precision"]], c(FALSE, TRUE))
})

# fct -> lgl -------------------------------------------------------------------

test_that(".fct_to_lgl() converts TRUE/FALSE levels (#226, #237)", {
  res <- .fct_to_lgl(factor(c("TRUE", "FALSE", "T", "F")))
  expect_identical(res[["result"]], c(TRUE, FALSE, TRUE, FALSE))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE, TRUE))
})

test_that(".fct_to_lgl() passes NA factor element through; valid TRUE (#226, #237)", {
  res <- .fct_to_lgl(factor(c("TRUE", NA)))
  expect_identical(res[["result"]], c(TRUE, NA))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".fct_to_lgl() marks non-logical levels as not valid (#226, #237)", {
  res <- .fct_to_lgl(factor(c("a", "TRUE")))
  expect_identical(res[["result"]], c(NA, TRUE))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})

# chr -> fct (are_fctish) ------------------------------------------------------

test_that(".chr_are_fctish() returns all TRUE when levels is NULL (#226, #237)", {
  expect_identical(
    .chr_are_fctish(c("a", "b", NA)),
    c(TRUE, TRUE, TRUE)
  )
})

test_that(".chr_are_fctish() checks membership in levels (#226, #237)", {
  expect_identical(
    .chr_are_fctish(c("a", "b", "c"), levels = c("a", "b")),
    c(TRUE, TRUE, FALSE)
  )
})

test_that(".chr_are_fctish() treats NA as fctish regardless of levels (#226, #237)", {
  expect_identical(
    .chr_are_fctish(NA_character_, levels = c("a", "b")),
    TRUE
  )
})

test_that(".chr_are_fctish() treats to_na values as fctish (#226, #237)", {
  expect_identical(
    .chr_are_fctish(c("a", "z"), levels = c("a", "b"), to_na = "z"),
    c(TRUE, TRUE)
  )
})

# fct -> fct (are_fctish) ------------------------------------------------------

test_that(".fct_are_fctish() returns all TRUE when levels is NULL (#226, #237)", {
  expect_identical(
    .fct_are_fctish(factor(c("a", "b"))),
    c(TRUE, TRUE)
  )
})

test_that(".fct_are_fctish() checks factor level membership in target levels (#226, #237)", {
  f <- factor(c("a", "b", "c"))
  expect_identical(
    .fct_are_fctish(f, levels = c("a", "b")),
    c(TRUE, TRUE, FALSE)
  )
})

test_that(".fct_are_fctish() treats NA as fctish regardless of levels (#226, #237)", {
  f <- factor(c("a", NA))
  expect_identical(
    .fct_are_fctish(f, levels = c("a", "b")),
    c(TRUE, TRUE)
  )
})

# lst -> dbl -------------------------------------------------------------------

test_that(".lst_to_dbl() converts a flat list of numeric/lgl/int scalars (#226, #237)", {
  res <- .lst_to_dbl(list(1.0, 2L, TRUE))
  expect_identical(res[["result"]], c(1.0, 2.0, 1.0))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_dbl() converts numeric character strings (#226, #237)", {
  res <- .lst_to_dbl(list("1.5", "Inf", "-3.14"))
  expect_identical(res[["result"]], c(1.5, Inf, -3.14))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_dbl() marks non-parseable character strings as not valid (#226, #237)", {
  res <- .lst_to_dbl(list("a"))
  expect_identical(res[["result"]], NA_real_)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_dbl() converts complex with Im == 0 (#226, #237)", {
  res <- .lst_to_dbl(list(1 + 0i, -2 + 0i))
  expect_identical(res[["result"]], c(1.0, -2.0))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_dbl() marks complex with Im != 0 as not valid (#226, #237)", {
  res <- .lst_to_dbl(list(1 + 2i))
  expect_identical(res[["result"]], 1.0)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_dbl() converts factor elements via their level strings (#226, #237)", {
  res <- .lst_to_dbl(list(factor("1.5"), factor("a")))
  expect_identical(res[["result"]], c(1.5, NA_real_))
  expect_identical(res[["valid"]], c(TRUE, FALSE))
})

test_that(".lst_to_dbl() passes NA through; valid TRUE (#226, #237)", {
  res <- .lst_to_dbl(list(NA_real_))
  expect_identical(res[["result"]], NA_real_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_dbl() passes NA_character_ through; valid TRUE (#226, #237)", {
  res <- .lst_to_dbl(list(NA_character_))
  expect_identical(res[["result"]], NA_real_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_dbl() unpacks a one-element list with a double vector (#237)", {
  res <- .lst_to_dbl(list(c(1.0, 2.0)))
  expect_identical(res[["result"]], c(1.0, 2.0))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_dbl() unpacks a one-element list with an integer vector (#237)", {
  res <- .lst_to_dbl(list(1:3))
  expect_identical(res[["result"]], c(1.0, 2.0, 3.0))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_dbl() unpacks a one-element list with a character vector (#237)", {
  res <- .lst_to_dbl(list(c("1.5", "2.5")))
  expect_identical(res[["result"]], c(1.5, 2.5))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_dbl() marks non-coercible single-element as not valid (#237)", {
  res <- .lst_to_dbl(list(list(1.0, 2.0)))
  expect_identical(res[["result"]], NA_real_)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_dbl() unwraps singly-nested lists (#239)", {
  res <- .lst_to_dbl(list(list(1.0), 1.0))
  expect_identical(res[["result"]], rep(1.0, 2))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_dbl() marks multiply-nested lists as not valid (#239)", {
  res <- .lst_to_dbl(list(list(c(1.0, 2.0)), 1.0))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})

test_that(".lst_to_dbl() marks non-scalar elements in multi-element lists as not valid (#226, #237)", {
  res <- .lst_to_dbl(list(c(1.0, 2.0), 3.0))
  expect_identical(res[["result"]], c(NA_real_, 3.0))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})

# lst -> int -------------------------------------------------------------------

test_that(".lst_to_int() converts a flat list of integer/logical scalars (#226, #237)", {
  res <- .lst_to_int(list(1L, FALSE, TRUE))
  expect_identical(res[["result"]], c(1L, 0L, 1L))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_int() converts whole-number doubles (#226, #237)", {
  res <- .lst_to_int(list(1.0, 2.0))
  expect_identical(res[["result"]], c(1L, 2L))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_int() converts integer-valued character strings (#226, #237)", {
  res <- .lst_to_int(list("1", "2", "3"))
  expect_identical(res[["result"]], c(1L, 2L, 3L))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_int() marks fractional character strings as not valid (#226, #237)", {
  res <- .lst_to_int(list("1.5"))
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_int() marks non-number character strings as not valid (#226, #237)", {
  res <- .lst_to_int(list("a"))
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_int() converts complex with Im == 0 and whole Re (#226, #237)", {
  res <- .lst_to_int(list(2 + 0i))
  expect_identical(res[["result"]], 2L)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_int() marks complex with Im != 0 as not valid (#226, #237)", {
  res <- .lst_to_int(list(1 + 2i))
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_int() converts factor elements via their level strings (#226, #237)", {
  res <- .lst_to_int(list(factor("2"), factor("1.5")))
  expect_identical(res[["result"]], c(2L, NA_integer_))
  expect_identical(res[["valid"]], c(TRUE, FALSE))
})

test_that(".lst_to_int() passes NA through; valid TRUE (#226, #237)", {
  res <- .lst_to_int(list(NA_integer_))
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_int() passes NA_character_ through; valid TRUE (#226, #237)", {
  res <- .lst_to_int(list(NA_character_))
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_int() marks fractional doubles as not valid (#226, #237)", {
  res <- .lst_to_int(list(1.5))
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_int() unpacks a one-element list with an integer vector (#237)", {
  res <- .lst_to_int(list(1:3))
  expect_identical(res[["result"]], c(1L, 2L, 3L))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_int() unpacks a one-element list with a character vector (#237)", {
  res <- .lst_to_int(list(c("1", "2", "3")))
  expect_identical(res[["result"]], c(1L, 2L, 3L))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_int() unpacks a one-element list with a double vector (#237)", {
  res <- .lst_to_int(list(c(1.0, 2.0)))
  expect_identical(res[["result"]], c(1L, 2L))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_int() marks non-coercible single-element as not valid (#226, #237)", {
  res <- .lst_to_int(list(list(1L, 2L)))
  expect_identical(res[["result"]], NA_integer_)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_int() unwraps singly-nested lists (#239)", {
  res <- .lst_to_int(list(list(1L), 1L))
  expect_identical(res[["result"]], rep(1L, 2))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_int() marks multiply-nested lists as not valid (#239)", {
  res <- .lst_to_int(list(list(c(1L, 2L)), 1L))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})

test_that(".lst_to_int() marks non-scalar elements in multi-element lists as not valid (#226, #237)", {
  res <- .lst_to_int(list(c(1L, 2L), 3L))
  expect_identical(res[["result"]], c(NA_integer_, 3L))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})

# lst -> lgl -------------------------------------------------------------------

test_that(".lst_to_lgl() converts a flat list of lgl/int/dbl scalars (#226, #237)", {
  res <- .lst_to_lgl(list(TRUE, 0L, 1.0))
  expect_identical(res[["result"]], c(TRUE, FALSE, TRUE))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_lgl() converts lgl-ish character strings (#226, #237)", {
  res <- .lst_to_lgl(list("TRUE", "FALSE", "T", "F", "1", "0"))
  expect_identical(res[["result"]], c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE))
  expect_identical(res[["valid"]], rep(TRUE, 6))
})

test_that(".lst_to_lgl() marks non-lgl character strings as not valid (#226, #237)", {
  res <- .lst_to_lgl(list("a"))
  expect_identical(res[["result"]], NA)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_lgl() converts factor elements via their level strings (#226, #237)", {
  res <- .lst_to_lgl(list(factor("TRUE"), factor("a")))
  expect_identical(res[["result"]], c(TRUE, NA))
  expect_identical(res[["valid"]], c(TRUE, FALSE))
})

test_that(".lst_to_lgl() passes NA through; valid TRUE (#226, #237)", {
  res <- .lst_to_lgl(list(NA))
  expect_identical(res[["result"]], NA)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_lgl() passes NA_character_ through; valid TRUE (#226, #237)", {
  res <- .lst_to_lgl(list(NA_character_))
  expect_identical(res[["result"]], NA)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_lgl() unpacks a one-element list with a logical vector (#237)", {
  res <- .lst_to_lgl(list(c(TRUE, FALSE)))
  expect_identical(res[["result"]], c(TRUE, FALSE))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_lgl() unpacks a one-element list with a character vector (#237)", {
  res <- .lst_to_lgl(list(c("TRUE", "FALSE", "1")))
  expect_identical(res[["result"]], c(TRUE, FALSE, TRUE))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_lgl() marks non-coercible single-element as not valid (#226, #237)", {
  res <- .lst_to_lgl(list(c(1 + 2i, 3 + 4i)))
  expect_identical(res[["result"]], NA)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_lgl() unwraps singly-nested lists (#239)", {
  res <- .lst_to_lgl(list(list(TRUE), TRUE))
  expect_identical(res[["result"]], rep(TRUE, 2))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_lgl() marks multiply-nested lists as not valid (#239)", {
  res <- .lst_to_lgl(list(list(c(TRUE, FALSE)), TRUE))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})

test_that(".lst_to_lgl() marks non-scalar elements in multi-element lists as not valid (#226, #237)", {
  res <- .lst_to_lgl(list(c(TRUE, FALSE), TRUE))
  expect_identical(res[["result"]], c(NA, TRUE))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})

# lst -> chr -------------------------------------------------------------------

test_that(".lst_to_chr() passes character scalars through; valid TRUE (#226, #237)", {
  res <- .lst_to_chr(list("a", "b", "c"))
  expect_identical(res[["result"]], c("a", "b", "c"))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_chr() passes NA_character_ through; valid TRUE (#226, #237)", {
  res <- .lst_to_chr(list(NA_character_))
  expect_identical(res[["result"]], NA_character_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_chr() converts non-character atomic scalars to strings (#226, #237, #239)", {
  res <- .lst_to_chr(list(1.0, 1L, TRUE))
  expect_identical(res[["result"]], c("1", "1", "TRUE"))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_chr() converts factor elements via their level labels (#226, #237, #239)", {
  res <- .lst_to_chr(list(factor("a")))
  expect_identical(res[["result"]], "a")
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_chr() unpacks a one-element list with a character vector (#237)", {
  res <- .lst_to_chr(list(c("a", "b")))
  expect_identical(res[["result"]], c("a", "b"))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_chr() marks non-character single-element vectors as not valid (#226, #237)", {
  res <- .lst_to_chr(list(c(1L, 2L, 3L)))
  expect_identical(res[["result"]], NA_character_)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_chr() marks non-scalar elements in multi-element lists as not valid (#226, #237)", {
  res <- .lst_to_chr(list(c("a", "b"), "c"))
  expect_identical(res[["result"]], c(NA_character_, "c"))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})


test_that(".lst_to_chr() unwraps singly-nested lists (#239)", {
  res <- .lst_to_chr(list(list("a"), "b"))
  expect_identical(res[["result"]], c("a", "b"))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_chr() marks multiply-nested lists as not valid (#239)", {
  res <- .lst_to_chr(list(list("a", "b"), "c"))
  expect_identical(res[["result"]], c(NA_character_, "c"))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})
# lst -> fct -------------------------------------------------------------------

test_that(".lst_to_fct() passes character scalars through; valid TRUE (#226, #237)", {
  res <- .lst_to_fct(list("a", "b", "c"))
  expect_identical(res[["result"]], c("a", "b", "c"))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_fct() passes NA_character_ through; valid TRUE (#226, #237)", {
  res <- .lst_to_fct(list(NA_character_))
  expect_identical(res[["result"]], NA_character_)
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_fct() marks non-character scalars as not valid (#226, #237)", {
  res <- .lst_to_fct(list(1.0, 1L, TRUE))
  expect_identical(
    res[["result"]],
    c(NA_character_, NA_character_, NA_character_)
  )
  expect_identical(res[["valid"]], c(FALSE, FALSE, FALSE))
})

test_that(".lst_to_fct() marks factor elements as valid (#226, #237)", {
  res <- .lst_to_fct(list(factor("a")))
  expect_identical(res[["result"]], "a")
  expect_identical(res[["valid"]], TRUE)
})

test_that(".lst_to_fct() unpacks a one-element list with a character vector (#237)", {
  res <- .lst_to_fct(list(c("a", "b")))
  expect_identical(res[["result"]], c("a", "b"))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_fct() unpacks a one-element list with a factor (#237)", {
  res <- .lst_to_fct(list(factor(c("x", "y", "z"))))
  expect_identical(res[["result"]], c("x", "y", "z"))
  expect_identical(res[["valid"]], c(TRUE, TRUE, TRUE))
})

test_that(".lst_to_fct() marks non-character/factor single-element vectors as not valid (#226, #237)", {
  res <- .lst_to_fct(list(c(1L, 2L, 3L)))
  expect_identical(res[["result"]], NA_character_)
  expect_identical(res[["valid"]], FALSE)
})

test_that(".lst_to_fct() marks non-scalar elements in multi-element lists as not valid (#226, #237)", {
  res <- .lst_to_fct(list(c("a", "b"), "c"))
  expect_identical(res[["result"]], c(NA_character_, "c"))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})

test_that(".lst_to_fct() unwraps singly-nested lists (#239)", {
  res <- .lst_to_fct(list(list("a"), "b"))
  expect_identical(res[["result"]], c("a", "b"))
  expect_identical(res[["valid"]], c(TRUE, TRUE))
})

test_that(".lst_to_fct() marks multiply-nested lists as not valid (#239)", {
  res <- .lst_to_fct(list(list("a", "b"), "c"))
  expect_identical(res[["valid"]], c(FALSE, TRUE))
})

# range checks -----------------------------------------------------------------

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
