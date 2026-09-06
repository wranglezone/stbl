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

test_that("stabilize_int() attaches value failure locations (#274)", {
  cnd <- rlang::catch_cnd(stabilize_int(c(1L, 5L, 2L, 8L), min_value = 3))
  expect_identical(cnd$locations, c(1L, 3L))
})

test_that("stabilize_int() enforces unique elements (#280)", {
  expect_identical(stabilize_int(c(1L, 2L), unique = TRUE), c(1L, 2L))
  expect_pkg_error_classes(
    stabilize_int(c(1L, 2L, 1L), unique = TRUE),
    "stbl",
    "duplicate_elements"
  )
})

test_that("stabilize_int() reports duplicate locations, including NA duplicates (#280)", {
  cnd <- rlang::catch_cnd(stabilize_int(
    c(1L, 1L, NA_integer_, NA_integer_),
    unique = TRUE
  ))
  expect_identical(cnd$locations, c(2L, 4L))
})

test_that("stabilize_int() checks allowed_values (#282)", {
  expect_identical(
    stabilize_int(1:3, allowed_values = c(1L, 2L, 3L)),
    1:3
  )
  expect_pkg_error_snapshot(
    stabilize_int(1:5, allowed_values = c(1L, 2L, 3L)),
    "stbl",
    "allowed_values"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_int(1:5, allowed_values = c(1L, 2L, 3L)),
    "stbl",
    "allowed_values"
  )
})

test_that("stabilize_int() checks multiple_of (#283)", {
  expect_identical(
    stabilize_int(c(2L, 4L, 6L), multiple_of = 2),
    c(2L, 4L, 6L)
  )
  expect_pkg_error_snapshot(
    stabilize_int(c(2L, 3L, 6L), multiple_of = 2),
    "stbl",
    "not_multiple"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_int(c(2L, 3L, 6L), multiple_of = 2),
    "stbl",
    "not_multiple"
  )
})

test_that("stabilize_int() rejects a non-positive multiple_of (#283)", {
  expect_pkg_error_classes(
    stabilize_int(1:5, multiple_of = -2),
    "stbl",
    "bad_multiple_of"
  )
})

test_that("stabilize_int_scalar() checks multiple_of (#283)", {
  expect_identical(
    stabilize_int_scalar(4L, multiple_of = 2),
    4L
  )
  expect_pkg_error_snapshot(
    stabilize_int_scalar(3L, multiple_of = 2),
    "stbl",
    "not_multiple"
  )
})

test_that("stabilize_int() checks exclusive_min_value (#276)", {
  given <- 1:10
  expect_identical(
    stabilize_int(given, exclusive_min_value = 0),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_int(given, exclusive_min_value = 1),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_int(given, exclusive_min_value = 1),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_int() checks exclusive_max_value (#276)", {
  given <- 1:10
  expect_identical(
    stabilize_int(given, exclusive_max_value = 11),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_int(given, exclusive_max_value = 10),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_int(given, exclusive_max_value = 10),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_int() attaches exclusive value failure locations (#276)", {
  cnd <- rlang::catch_cnd(
    stabilize_int(c(1L, 5L, 2L, 8L), exclusive_max_value = 5L)
  )
  expect_identical(cnd$locations, c(2L, 4L))
})

test_that("stabilize_int_scalar() checks exclusive_min_value and exclusive_max_value (#276)", {
  expect_identical(
    stabilize_int_scalar(5L, exclusive_min_value = 1, exclusive_max_value = 10),
    5L
  )
  expect_pkg_error_snapshot(
    stabilize_int_scalar(1L, exclusive_min_value = 1),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    stabilize_int_scalar(10L, exclusive_max_value = 10),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_int_scalar() checks allowed_values (#282)", {
  expect_identical(
    stabilize_int_scalar(1L, allowed_values = c(1L, 2L)),
    1L
  )
  expect_pkg_error_snapshot(
    stabilize_int_scalar(5L, allowed_values = c(1L, 2L)),
    "stbl",
    "allowed_values"
  )
})
