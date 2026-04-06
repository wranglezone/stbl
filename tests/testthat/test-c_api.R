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
