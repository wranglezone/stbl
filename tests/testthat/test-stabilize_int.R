test_that("stabilize_int() checks min_value (#2, #6)", {
  given <- 1:10
  expect_identical(
    stabilize_int(given, min_value = 1, max_value = 10),
    given
  )
  expect_error(
    stabilize_int(given, min_value = 11),
    class = .compile_dash("stbl", "error", "outside_range")
  )
  expect_snapshot(
    stabilize_int(given, min_value = 11),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_int(given, min_value = 11),
    error = TRUE
  )
})

test_that("stabilize_int() checks max_value (#5)", {
  given <- 1:10
  expect_error(
    stabilize_int(given, max_value = 4),
    class = .compile_dash("stbl", "error", "outside_range")
  )
  expect_snapshot(
    stabilize_int(given, max_value = 4),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_int(given, max_value = 4),
    error = TRUE
  )
})

test_that("stabilize_int_scalar() allows length-1 ints through (#12)", {
  given <- 1L
  expect_identical(stabilize_int_scalar(given), given)
})

test_that("stabilize_int_scalar() errors on non-scalars (#12)", {
  given <- 1:10
  expect_error(
    stabilize_int_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    stabilize_int_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_int_scalar(given),
    error = TRUE
  )
})
