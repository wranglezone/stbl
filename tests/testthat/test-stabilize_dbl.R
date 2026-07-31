test_that("stabilize_dbl() checks min_value (#23, #176)", {
  given <- 1.1:10.1
  expect_identical(
    stabilize_dbl(given, min_value = 1.1, max_value = 10.1),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_dbl(given, min_value = 11.1),
    "stbl",
    "outside_range"
  )
  expect_snapshot(
    stabilize_dbl(given[[1]], min_value = 11.1),
    error = TRUE
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dbl(given, min_value = 11.1),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_dbl() checks max_value (#23, #176)", {
  given <- 1.1:10.1
  expect_pkg_error_snapshot(
    stabilize_dbl(given, max_value = 4.1),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dbl(given, max_value = 4.1),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_dbl_scalar() allows length-1 dbls through (#23, #189)", {
  given <- 1.1
  expect_identical(stabilize_dbl_scalar(given), given)
  expect_null(stabilize_dbl_scalar(NULL, allow_null = TRUE))
})

test_that("stabilize_dbl_scalar() respects allow_null (#23, #189)", {
  given <- NULL
  expect_pkg_error_snapshot(stabilize_dbl_scalar(given), "stbl", "bad_null")
  expect_pkg_error_snapshot(
    wrapped_stabilize_dbl_scalar(given),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_dbl_scalar() errors on non-scalars (#23)", {
  given <- 1.1:10.1
  expect_pkg_error_snapshot(stabilize_dbl_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    wrapped_stabilize_dbl_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("stabilise_dbl() exists (#167)", {
  expect_no_error(stabilise_dbl(TRUE))
})

test_that("stabilize_double() exists (#164)", {
  expect_no_error(stabilize_double(TRUE))
})

test_that("stabilise_double() exists (#167)", {
  expect_no_error(stabilise_double(TRUE))
})

test_that("stabilise_dbl_scalar() exists (#167)", {
  expect_no_error(stabilise_dbl_scalar(TRUE))
})

test_that("stabilize_double_scalar() exists (#164)", {
  expect_no_error(stabilize_double_scalar(TRUE))
})

test_that("stabilise_double_scalar() exists (#167)", {
  expect_no_error(stabilise_double_scalar(TRUE))
})
