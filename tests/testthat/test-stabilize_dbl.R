test_that("stabilize_dbl() checks min_value (#23)", {
  given <- 1.1:10.1
  expect_identical(
    stabilize_dbl(given, min_value = 1.1, max_value = 10.1),
    given
  )
  expect_error(
    stabilize_dbl(given, min_value = 11.1),
    class = .compile_dash("stbl", "error", "outside_range")
  )
  expect_snapshot(
    stabilize_dbl(given, min_value = 11.1),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_dbl(given, min_value = 11.1),
    error = TRUE
  )
})

test_that("stabilize_dbl() checks max_value (#23)", {
  given <- 1.1:10.1
  expect_error(
    stabilize_dbl(given, max_value = 4.1),
    class = .compile_dash("stbl", "error", "outside_range")
  )
  expect_snapshot(
    stabilize_dbl(given, max_value = 4.1),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_dbl(given, max_value = 4.1),
    error = TRUE
  )
})

test_that("stabilize_dbl_scalar() allows length-1 dbls through (#23)", {
  given <- 1.1
  expect_identical(stabilize_dbl_scalar(given), given)
})

test_that("stabilize_dbl_scalar() errors on non-scalars (#23)", {
  given <- 1.1:10.1
  expect_error(
    stabilize_dbl_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    stabilize_dbl_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_dbl_scalar(given),
    error = TRUE
  )
})

test_that("stabilize_double() exists (#164)", {
  expect_no_error(stabilize_double(TRUE))
})

test_that("stabilize_double_scalar() exists (#164)", {
  expect_no_error(stabilize_double_scalar(TRUE))
})
