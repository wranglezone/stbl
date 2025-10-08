test_that("stabilize_dbl() checks min_value", {
  given <- 1.1:10.1
  testthat::expect_identical(
    stabilize_dbl(given, min_value = 1.1, max_value = 10.1),
    given
  )
  testthat::expect_error(
    stabilize_dbl(given, min_value = 11.1),
    class = .compile_dash("stbl", "error", "outside_range")
  )
  testthat::expect_snapshot(
    stabilize_dbl(given, min_value = 11.1),
    error = TRUE
  )
  testthat::expect_snapshot(
    wrapped_stabilize_dbl(given, min_value = 11.1),
    error = TRUE
  )
})

test_that("stabilize_dbl() checks max_value", {
  given <- 1.1:10.1
  testthat::expect_error(
    stabilize_dbl(given, max_value = 4.1),
    class = .compile_dash("stbl", "error", "outside_range")
  )
  testthat::expect_snapshot(
    stabilize_dbl(given, max_value = 4.1),
    error = TRUE
  )
  testthat::expect_snapshot(
    wrapped_stabilize_dbl(given, max_value = 4.1),
    error = TRUE
  )
})

test_that("stabilize_dbl_scalar() allows length-1 dbls through", {
  given <- 1.1
  testthat::expect_identical(stabilize_dbl_scalar(given), given)
})

test_that("stabilize_dbl_scalar() errors on non-scalars", {
  given <- 1.1:10.1
  testthat::expect_error(
    stabilize_dbl_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  testthat::expect_snapshot(
    stabilize_dbl_scalar(given),
    error = TRUE
  )
  testthat::expect_snapshot(
    wrapped_stabilize_dbl_scalar(given),
    error = TRUE
  )
})
