test_that("stabilize_lgl() works on happy path (#28)", {
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

test_that("stabilize_lgl() checks NAs (#28)", {
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

test_that("stabilize_lgl() checks min_size (#28)", {
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

test_that("stabilize_lgl() checks max_size (#28)", {
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

test_that("stabilize_lgl_scalar() allows length-1 lgls through (#28)", {
  expect_true(stabilize_lgl_scalar(TRUE))
})

test_that("stabilize_lgl_scalar() errors on non-scalars (#28)", {
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

test_that("stabilise_lgl() exists (#167)", {
  expect_no_error(stabilise_lgl(TRUE))
})

test_that("stabilize_logical() exists (#164)", {
  expect_no_error(stabilize_logical(TRUE))
})

test_that("stabilise_logical() exists (#167)", {
  expect_no_error(stabilise_logical(TRUE))
})

test_that("stabilise_lgl_scalar() exists (#167)", {
  expect_no_error(stabilise_lgl_scalar(TRUE))
})

test_that("stabilize_logical_scalar() exists (#164)", {
  expect_no_error(stabilize_logical_scalar(TRUE))
})

test_that("stabilise_logical_scalar() exists (#167)", {
  expect_no_error(stabilize_logical_scalar(TRUE))
})
