test_that("stabilize_arg() returns its inputs for default settings (#11)", {
  given <- 1:2
  expect_identical(stabilize_arg(given), given)
  expect_identical(stabilize_arg(NULL), NULL)
})

test_that("stabilize_arg() complains about weird args (#11)", {
  # This error is from rlang, so just watch for that error class
  expect_error(
    stabilize_arg(1L, new_arg = "red"),
    class = "rlib_error_dots_nonempty"
  )
  expect_snapshot(
    stabilize_arg(1L, new_arg = "red"),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_arg(1L, new_arg = "red"),
    error = TRUE
  )
})

test_that("stabilize_arg() rejects NULLs when asked (#11)", {
  given <- NULL
  expect_error(
    stabilize_arg(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    stabilize_arg(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_arg(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("stabilize_arg() checks NAs (#11)", {
  given <- 1:8
  expect_identical(stabilize_arg(given, allow_na = FALSE), given)

  given[c(4, 7)] <- NA
  expect_error(
    stabilize_arg(given, allow_na = FALSE),
    class = .compile_dash("stbl", "error", "bad_na")
  )
  expect_snapshot(
    stabilize_arg(given, allow_na = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_arg(given, allow_na = FALSE),
    error = TRUE
  )
})

test_that("stabilize_arg() checks size args (#11)", {
  given <- TRUE
  expect_true(stabilize_arg(given, min_size = 1, max_size = 1))

  expect_error(
    stabilize_arg(given, min_size = 2, max_size = 1),
    class = .compile_dash("stbl", "error", "size_x_vs_y")
  )
  expect_snapshot(
    stabilize_arg(given, min_size = 2, max_size = 1),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_arg(given, min_size = 2, max_size = 1),
    error = TRUE
  )
})

test_that("stabilize_arg() checks min_size (#11)", {
  given <- 1:3
  expect_identical(
    stabilize_arg(given, min_size = 1, max_size = 10),
    given
  )

  expect_error(
    stabilize_arg(given, min_size = 11),
    class = .compile_dash("stbl", "error", "size_too_small")
  )
  expect_snapshot(
    stabilize_arg(given, min_size = 11),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_arg(given, min_size = 11),
    error = TRUE
  )
})

test_that("stabilize_arg() checks max_size (#11)", {
  given <- 1:3
  expect_error(
    stabilize_arg(given, max_size = 2),
    class = .compile_dash("stbl", "error", "size_too_large")
  )
  expect_snapshot(
    stabilize_arg(given, max_size = 2),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_arg(given, max_size = 2),
    error = TRUE
  )
})


test_that("stabilize_arg_scalar() allows length-1 args through (#12)", {
  given <- 1L
  expect_identical(stabilize_arg_scalar(given), given)
})

test_that("stabilize_arg_scalar() errors for non-scalars (#12)", {
  given <- 1:10
  expect_error(
    stabilize_arg_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    stabilize_arg_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_arg_scalar(given),
    error = TRUE
  )
})

test_that("stabilize_arg_scalar() respects allow_null (#12)", {
  given <- NULL
  expect_error(
    stabilize_arg_scalar(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    stabilize_arg_scalar(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_arg_scalar(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("stabilize_arg_scalar() errors on weird internal arg values (#12)", {
  given <- NULL
  expect_error(
    stabilize_arg_scalar(given, allow_null = c(TRUE, FALSE)),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    stabilize_arg_scalar(given, allow_null = c(TRUE, FALSE)),
    error = TRUE
  )
})
