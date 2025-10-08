test_that("stabilize_lgl() works on happy path", {
  given <- TRUE
  expect_true(stabilize_lgl(given))
  given <- FALSE
  expect_false(stabilize_lgl(given))

  given <- c("TRUE", "FALSE", "true", "fALSE")
  expect_identical(
    stabilize_lgl(given),
    c(TRUE, FALSE, TRUE, FALSE)
  )
})

test_that("stabilize_lgl() checks NAs", {
  given <- c("TRUE", NA, "true", "fALSE")
  expect_identical(
    stabilize_lgl(given),
    c(TRUE, NA, TRUE, FALSE)
  )
  expect_error(
    stabilize_lgl(given, allow_na = FALSE),
    class = .compile_dash("stbl", "error", "bad_na")
  )
  expect_snapshot(
    stabilize_lgl(given, allow_na = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_lgl(given, allow_na = FALSE),
    error = TRUE
  )
})

test_that("stabilize_lgl() checks min_size", {
  given <- c("TRUE", NA, "true", "fALSE")
  expect_error(
    stabilize_lgl(given, min_size = 5),
    class = .compile_dash("stbl", "error", "size_too_small")
  )
  expect_snapshot(
    stabilize_lgl(given, min_size = 5),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_lgl(given, min_size = 5),
    error = TRUE
  )
})

test_that("stabilize_lgl() checks max_size", {
  given <- c("TRUE", NA, "true", "fALSE")
  expect_error(
    stabilize_lgl(given, max_size = 3),
    class = .compile_dash("stbl", "error", "size_too_large")
  )
  expect_snapshot(
    stabilize_lgl(given, max_size = 3),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_lgl(given, max_size = 3),
    error = TRUE
  )
})

test_that("stabilize_lgl_scalar() allows length-1 lgls through", {
  expect_true(stabilize_lgl_scalar(TRUE))
})

test_that("stabilize_lgl_scalar() errors on non-scalars", {
  given <- c(TRUE, FALSE, TRUE)
  expect_error(
    stabilize_lgl_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    stabilize_lgl_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_lgl_scalar(given),
    error = TRUE
  )
})
