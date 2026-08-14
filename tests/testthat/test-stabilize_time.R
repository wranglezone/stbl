test_that("stabilize_time() coerces and returns times (#294)", {
  given <- c("13:20:00Z", "14:20:00Z")
  expect_identical(stabilize_time(given), to_time(given))
})

test_that("stabilize_time() works for NULL (#294)", {
  expect_null(stabilize_time(NULL))
  expect_pkg_error_snapshot(
    stabilize_time(NULL, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_time() respects allow_na (#294)", {
  given <- to_time(c("13:20:00Z", NA))
  expect_identical(stabilize_time(given), given)
  expect_pkg_error_snapshot(
    stabilize_time(given, allow_na = FALSE),
    "stbl",
    "bad_na"
  )
})

test_that("stabilize_time() checks min_value (#294)", {
  given <- to_time(c("06:00:00Z", "14:00:00Z"))
  expect_identical(
    stabilize_time(given, min_value = "00:00:00Z", max_value = "23:00:00Z"),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_time(given, min_value = "12:00:00Z"),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_time(given, min_value = "12:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_time() checks max_value (#294)", {
  given <- to_time(c("06:00:00Z", "14:00:00Z"))
  expect_pkg_error_snapshot(
    stabilize_time(given, max_value = "10:00:00Z"),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_time(given, max_value = "10:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_time() attaches value failure locations (#294)", {
  cnd <- rlang::catch_cnd(stabilize_time(
    to_time(c("06:00:00Z", "18:00:00Z", "07:00:00Z")),
    min_value = "12:00:00Z"
  ))
  expect_identical(cnd$locations, c(1L, 3L))
})

test_that("stabilize_time() checks size (#294)", {
  given <- to_time(c("06:00:00Z", "14:00:00Z"))
  expect_pkg_error_snapshot(
    stabilize_time(given, min_size = 3),
    "stbl",
    "size_too_small"
  )
  expect_pkg_error_snapshot(
    stabilize_time(given, max_size = 1),
    "stbl",
    "size_too_large"
  )
})

test_that("stabilize_time() enforces unique elements (#294)", {
  given <- to_time(c("06:00:00Z", "14:00:00Z"))
  expect_identical(stabilize_time(given, unique = TRUE), given)
  expect_pkg_error_classes(
    stabilize_time(
      to_time(c("06:00:00Z", "06:00:00Z")),
      unique = TRUE
    ),
    "stbl",
    "duplicate_elements"
  )
})

test_that("stabilize_time() checks allowed_values (#294)", {
  given <- to_time(c("06:00:00Z", "14:00:00Z"))
  expect_identical(
    stabilize_time(given, allowed_values = c("06:00:00Z", "14:00:00Z")),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_time(given, allowed_values = "06:00:00Z"),
    "stbl",
    "allowed_values"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_time(given, allowed_values = "06:00:00Z"),
    "stbl",
    "allowed_values"
  )
})

test_that("stabilize_time() rejects times without an offset (#294)", {
  expect_pkg_error_snapshot(
    stabilize_time("13:20:00"),
    "stbl",
    "incompatible_values",
    "time"
  )
})

test_that("stabilise_time() exists (#294)", {
  expect_no_error(stabilise_time("13:20:00Z"))
})

test_that("stabilize_time_scalar() allows length-1 times through (#294)", {
  given <- to_time("13:20:00Z")
  expect_identical(stabilize_time_scalar(given), given)
  expect_null(stabilize_time_scalar(NULL, allow_null = TRUE))
})

test_that("stabilize_time_scalar() respects allow_null (#294)", {
  expect_pkg_error_snapshot(stabilize_time_scalar(NULL), "stbl", "bad_null")
  expect_pkg_error_snapshot(
    wrapped_stabilize_time_scalar(NULL),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_time_scalar() errors on non-scalars (#294)", {
  given <- to_time(c("13:20:00Z", "14:20:00Z"))
  expect_pkg_error_snapshot(stabilize_time_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    wrapped_stabilize_time_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("stabilize_time_scalar() checks allowed_values (#294)", {
  expect_identical(
    stabilize_time_scalar(
      "13:20:00Z",
      allowed_values = c("13:20:00Z", "14:20:00Z")
    ),
    to_time("13:20:00Z")
  )
  expect_pkg_error_snapshot(
    stabilize_time_scalar("06:00:00Z", allowed_values = "13:20:00Z"),
    "stbl",
    "allowed_values"
  )
})

test_that("stabilise_time_scalar() exists (#294)", {
  expect_no_error(stabilise_time_scalar("13:20:00Z"))
})
