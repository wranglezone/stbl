test_that("stabilize_int() checks min_value (#2, #6, #176)", {
  given <- 1:10
  expect_identical(
    stabilize_int(given, min_value = 1, max_value = 10),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_int(given, min_value = 11),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_int(given, min_value = 11),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_int() checks max_value (#5, #176)", {
  given <- 1:10
  expect_pkg_error_snapshot(
    stabilize_int(given, max_value = 4),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_int(given, max_value = 4),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_int_scalar() allows length-1 ints through (#12, #189)", {
  given <- 1L
  expect_identical(stabilize_int_scalar(given), given)
  expect_null(stabilize_int_scalar(NULL, allow_null = TRUE))
})

test_that("stabilize_int_scalar() respects allow_null (#12, #189)", {
  given <- NULL
  expect_pkg_error_snapshot(stabilize_int_scalar(given), "stbl", "bad_null")
  expect_pkg_error_snapshot(
    wrapped_stabilize_int_scalar(given),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_int_scalar() errors on non-scalars (#12)", {
  given <- 1:10
  expect_pkg_error_snapshot(stabilize_int_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    wrapped_stabilize_int_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("stabilise_int() exists (#167)", {
  expect_no_error(stabilise_int(TRUE))
})

test_that("stabilize_integer() exists (#164)", {
  expect_no_error(stabilize_integer(TRUE))
})

test_that("stabilise_integer() exists (#167)", {
  expect_no_error(stabilise_integer(TRUE))
})

test_that("stabilise_int_scalar() exists (#167)", {
  expect_no_error(stabilise_int_scalar(TRUE))
})

test_that("stabilize_integer_scalar() exists (#164)", {
  expect_no_error(stabilize_integer_scalar(TRUE))
})

test_that("stabilise_integer_scalar() exists (#167)", {
  expect_no_error(stabilise_integer_scalar(TRUE))
})
