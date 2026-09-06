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

test_that("stabilize_dbl() attaches value failure locations (#274)", {
  cnd <- rlang::catch_cnd(stabilize_dbl(c(1, 5, 2, 8), max_value = 4))
  expect_identical(cnd$locations, c(2L, 4L))
})

test_that("stabilize_dbl() enforces unique elements (#280)", {
  expect_identical(stabilize_dbl(c(1, 2), unique = TRUE), c(1, 2))
  expect_pkg_error_classes(
    stabilize_dbl(c(1, 2, 1), unique = TRUE),
    "stbl",
    "duplicate_elements"
  )
})

test_that("stabilize_dbl() reports duplicate locations, including NA duplicates (#280)", {
  cnd <- rlang::catch_cnd(stabilize_dbl(
    c(1, 1, NA_real_, NA_real_),
    unique = TRUE
  ))
  expect_identical(cnd$locations, c(2L, 4L))
})

test_that("stabilize_dbl() checks allowed_values (#282)", {
  expect_identical(
    stabilize_dbl(c(1.1, 2.2), allowed_values = c(1.1, 2.2, 3.3)),
    c(1.1, 2.2)
  )
  expect_pkg_error_snapshot(
    stabilize_dbl(c(1.1, 2.2, 3.3), allowed_values = c(1.1, 2.2)),
    "stbl",
    "allowed_values"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dbl(c(1.1, 2.2, 3.3), allowed_values = c(1.1, 2.2)),
    "stbl",
    "allowed_values"
  )
})

test_that("stabilize_dbl() checks multiple_of (#283)", {
  expect_identical(
    stabilize_dbl(c(0.1, 0.2, 0.3), multiple_of = 0.1),
    c(0.1, 0.2, 0.3)
  )
  expect_pkg_error_snapshot(
    stabilize_dbl(c(0.1, 0.25, 0.3), multiple_of = 0.1),
    "stbl",
    "not_multiple"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dbl(c(0.1, 0.25, 0.3), multiple_of = 0.1),
    "stbl",
    "not_multiple"
  )
})

test_that("stabilize_dbl() rejects a non-positive multiple_of (#283)", {
  expect_pkg_error_classes(
    stabilize_dbl(c(1, 2), multiple_of = 0),
    "stbl",
    "bad_multiple_of"
  )
})

test_that("stabilize_dbl_scalar() checks multiple_of (#283)", {
  expect_identical(
    stabilize_dbl_scalar(0.2, multiple_of = 0.1),
    0.2
  )
  expect_pkg_error_snapshot(
    stabilize_dbl_scalar(0.25, multiple_of = 0.1),
    "stbl",
    "not_multiple"
  )
})

test_that("stabilize_dbl() checks exclusive_min_value (#276)", {
  given <- 1.1:10.1
  expect_identical(
    stabilize_dbl(given, exclusive_min_value = 1),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_dbl(given, exclusive_min_value = 1.1),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dbl(given, exclusive_min_value = 1.1),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_dbl() checks exclusive_max_value (#276)", {
  given <- 1.1:10.1
  expect_identical(
    stabilize_dbl(given, exclusive_max_value = 10.2),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_dbl(given, exclusive_max_value = 10.1),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dbl(given, exclusive_max_value = 10.1),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_dbl() attaches exclusive value failure locations (#276)", {
  cnd <- rlang::catch_cnd(
    stabilize_dbl(c(1, 5, 2, 8), exclusive_max_value = 5)
  )
  expect_identical(cnd$locations, c(2L, 4L))
})

test_that("stabilize_dbl_scalar() checks exclusive_min_value and exclusive_max_value (#276)", {
  expect_identical(
    stabilize_dbl_scalar(5, exclusive_min_value = 1, exclusive_max_value = 10),
    5
  )
  expect_pkg_error_snapshot(
    stabilize_dbl_scalar(1, exclusive_min_value = 1),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    stabilize_dbl_scalar(10, exclusive_max_value = 10),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_dbl_scalar() checks allowed_values (#282)", {
  expect_identical(
    stabilize_dbl_scalar(1.1, allowed_values = c(1.1, 2.2)),
    1.1
  )
  expect_pkg_error_snapshot(
    stabilize_dbl_scalar(3.3, allowed_values = c(1.1, 2.2)),
    "stbl",
    "allowed_values"
  )
})
