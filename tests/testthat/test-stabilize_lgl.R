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
  expect_pkg_error_snapshot(
    stabilize_lgl(given, allow_na = FALSE),
    "stbl",
    "bad_na"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_lgl(given, allow_na = FALSE),
    "stbl",
    "bad_na"
  )
})

test_that("stabilize_lgl() checks min_size (#28)", {
  given <- c("TRUE", NA, "true", "fALSE")
  expect_pkg_error_snapshot(
    stabilize_lgl(given, min_size = 5),
    "stbl",
    "size_too_small"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_lgl(given, min_size = 5),
    "stbl",
    "size_too_small"
  )
})

test_that("stabilize_lgl() checks max_size (#28)", {
  given <- c("TRUE", NA, "true", "fALSE")
  expect_pkg_error_snapshot(
    stabilize_lgl(given, max_size = 3),
    "stbl",
    "size_too_large"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_lgl(given, max_size = 3),
    "stbl",
    "size_too_large"
  )
})

test_that("stabilize_lgl_scalar() allows length-1 lgls through (#28, #189)", {
  expect_true(stabilize_lgl_scalar(TRUE))
  expect_null(stabilize_lgl_scalar(NULL, allow_null = TRUE))
})

test_that("stabilize_lgl_scalar() respects allow_null (#28, #189)", {
  given <- NULL
  expect_pkg_error_snapshot(stabilize_lgl_scalar(given), "stbl", "bad_null")
  expect_pkg_error_snapshot(
    wrapped_stabilize_lgl_scalar(given),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_lgl_scalar() errors on non-scalars (#28)", {
  given <- c(TRUE, FALSE, TRUE)
  expect_pkg_error_snapshot(stabilize_lgl_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    wrapped_stabilize_lgl_scalar(given),
    "stbl",
    "non_scalar"
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
