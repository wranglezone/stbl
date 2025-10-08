test_that("to_dbl() works for dbls", {
  given <- c(1.1, 2.2)
  testthat::expect_identical(to_dbl(given), given)
})

test_that("to_dbl() works for ints", {
  given <- 1:10
  testthat::expect_identical(to_dbl(given), as.double(given))
})

test_that("to_dbl() works for NULL", {
  given <- NULL
  testthat::expect_identical(to_dbl(given), given)
})

test_that("to_dbl() respects allow_null", {
  given <- NULL
  testthat::expect_error(
    to_dbl(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  testthat::expect_snapshot(
    to_dbl(given, allow_null = FALSE),
    error = TRUE
  )
  testthat::expect_snapshot(
    wrapped_to_dbl(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_dbl() works for lgls", {
  given <- c(TRUE, FALSE)
  expected <- as.double(given)
  testthat::expect_identical(to_dbl(given), expected)
})

test_that("to_dbl() works for chrs", {
  expected <- c(1.1, 2.2)
  given <- as.character(expected)
  testthat::expect_identical(to_dbl(given), expected)
})

test_that("to_dbl() respects coerce_character", {
  expected <- c(1.1, 2.2)
  given <- as.character(expected)
  testthat::expect_error(
    to_dbl(given, coerce_character = FALSE),
    class = .compile_dash("stbl", "error", "coerce", "double")
  )
  testthat::expect_snapshot(
    to_dbl(given, coerce_character = FALSE),
    error = TRUE
  )
  testthat::expect_snapshot(
    wrapped_to_dbl(given, coerce_character = FALSE),
    error = TRUE
  )
})

test_that("to_dbl() errors informatively for bad chrs", {
  given <- c("1.1", "a")
  testthat::expect_error(
    to_dbl(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  testthat::expect_snapshot(
    to_dbl(given),
    error = TRUE
  )
  testthat::expect_snapshot(
    wrapped_to_dbl(given),
    error = TRUE
  )
})

test_that("to_dbl() works for complexes", {
  expected <- c(1.1, 2.2)
  given <- as.complex(expected)
  testthat::expect_identical(to_dbl(given), expected)
})

test_that("to_dbl() errors informatively for bad complexes", {
  given <- as.complex(c(1.1, 2.2))
  given[[1]] <- 1.1 + 1i
  testthat::expect_error(
    to_dbl(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  testthat::expect_snapshot(
    to_dbl(given),
    error = TRUE
  )
  testthat::expect_snapshot(
    wrapped_to_dbl(given),
    error = TRUE
  )
})

test_that("to_dbl() works for factors", {
  expected <- c(1.1, 3.3)
  given <- factor(expected)
  testthat::expect_identical(to_dbl(given), expected)
})

test_that("to_dbl() respects coerce_factor", {
  expected <- c(1.1, 3.3)
  given <- factor(expected)
  testthat::expect_error(
    to_dbl(given, coerce_factor = FALSE),
    class = .compile_dash("stbl", "error", "coerce", "double")
  )
  testthat::expect_snapshot(
    to_dbl(given, coerce_factor = FALSE),
    error = TRUE
  )
  testthat::expect_snapshot(
    wrapped_to_dbl(given, coerce_factor = FALSE),
    error = TRUE
  )
})

test_that("to_dbl() errors informatively for bad factors", {
  given <- factor(letters)
  testthat::expect_error(
    to_dbl(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  testthat::expect_snapshot(
    to_dbl(given),
    error = TRUE
  )
  testthat::expect_snapshot(
    wrapped_to_dbl(given),
    error = TRUE
  )
})

test_that("to_dbl() works for lists", {
  expect_identical(to_dbl(list(1.1, 2L, "3.3")), c(1.1, 2.0, 3.3))
  expect_identical(to_dbl(list(list(1.1), 2L)), c(1.1, 2.0))
  expect_error(
    to_dbl(list(1.1, 1:5)),
    class = .compile_dash("stbl", "error", "coerce", "double")
  )
})

test_that("to_dbl() errors properly for other types", {
  given <- as.raw(1:10)
  testthat::expect_error(to_dbl(given), class = "vctrs_error_cast")
  testthat::expect_error(to_dbl(mean), class = "vctrs_error_scalar_type")
})

test_that("to_dbl_scalar() allows length-1 dbls through", {
  given <- 1.1
  testthat::expect_identical(to_dbl_scalar(given), given)
})

test_that("to_dbl_scalar() provides informative error messages", {
  given <- c(1.1, 2.2)
  testthat::expect_error(
    to_dbl_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  testthat::expect_snapshot(
    to_dbl_scalar(given),
    error = TRUE
  )
  testthat::expect_snapshot(
    wrapped_to_dbl_scalar(given),
    error = TRUE
  )
})
