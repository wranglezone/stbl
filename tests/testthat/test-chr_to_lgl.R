test_that(".chr_to_lgl() converts TRUE/T strings to TRUE", {
  expect_identical(
    .chr_to_lgl(c("TRUE", "true", "T", "t")),
    c(TRUE, TRUE, TRUE, TRUE)
  )
})

test_that(".chr_to_lgl() converts FALSE/F strings to FALSE", {
  expect_identical(
    .chr_to_lgl(c("FALSE", "false", "F", "f")),
    c(FALSE, FALSE, FALSE, FALSE)
  )
})

test_that(".chr_to_lgl() passes NA through", {
  expect_identical(.chr_to_lgl(NA_character_), NA)
})

test_that(".chr_to_lgl() converts numeric strings", {
  expect_identical(
    .chr_to_lgl(c("0", "1", "-1", "1.5")),
    c(FALSE, TRUE, TRUE, TRUE)
  )
})

test_that(".chr_to_lgl() returns NA for invalid strings", {
  expect_identical(.chr_to_lgl(c("a", "", "NaN")), c(NA, NA, NA))
})

test_that(".chr_are_lglish() returns TRUE for convertible strings", {
  expect_identical(
    .chr_are_lglish(c("TRUE", "FALSE", "T", "F", "true", "false", "0", "1")),
    rep(TRUE, 8)
  )
})

test_that(".chr_are_lglish() returns TRUE for NA", {
  expect_identical(.chr_are_lglish(NA_character_), TRUE)
})

test_that(".chr_are_lglish() returns FALSE for invalid strings", {
  expect_identical(.chr_are_lglish(c("a", "", "NaN")), c(FALSE, FALSE, FALSE))
})
