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
