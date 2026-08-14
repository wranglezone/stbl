test_that("stabilize_dttm() coerces and returns date-times (#105)", {
  given <- c("2024-01-01T12:00:00Z", "2024-06-15T00:00:00Z")
  expect_identical(stabilize_dttm(given), to_dttm(given))
})

test_that("stabilize_dttm() normalizes to the requested tz (#105)", {
  result <- stabilize_dttm("2024-01-01T12:00:00Z", tz = "America/Chicago")
  expect_identical(attr(result, "tzone"), "America/Chicago")
})

test_that("stabilize_dttm() works for NULL (#105)", {
  expect_null(stabilize_dttm(NULL))
  expect_pkg_error_snapshot(
    stabilize_dttm(NULL, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_dttm() respects allow_na (#105)", {
  given <- to_dttm(c("2024-01-01T12:00:00Z", NA))
  expect_identical(stabilize_dttm(given), given)
  expect_pkg_error_snapshot(
    stabilize_dttm(given, allow_na = FALSE),
    "stbl",
    "bad_na"
  )
})

test_that("stabilize_dttm() checks min_value (#105)", {
  given <- to_dttm(c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z"))
  expect_identical(
    stabilize_dttm(
      given,
      min_value = "2024-01-01T00:00:00Z",
      max_value = "2024-12-31T00:00:00Z"
    ),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_dttm(given, min_value = "2024-06-01T00:00:00Z"),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dttm(given, min_value = "2024-06-01T00:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_dttm() checks max_value (#105)", {
  given <- to_dttm(c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z"))
  expect_pkg_error_snapshot(
    stabilize_dttm(given, max_value = "2024-03-01T00:00:00Z"),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dttm(given, max_value = "2024-03-01T00:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_dttm() attaches value failure locations (#105)", {
  cnd <- rlang::catch_cnd(stabilize_dttm(
    to_dttm(c(
      "2024-01-01T00:00:00Z",
      "2024-07-01T00:00:00Z",
      "2024-02-01T00:00:00Z"
    )),
    min_value = "2024-06-01T00:00:00Z"
  ))
  expect_identical(cnd$locations, c(1L, 3L))
})

test_that("stabilize_dttm() checks size (#105)", {
  given <- to_dttm(c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z"))
  expect_pkg_error_snapshot(
    stabilize_dttm(given, min_size = 3),
    "stbl",
    "size_too_small"
  )
  expect_pkg_error_snapshot(
    stabilize_dttm(given, max_size = 1),
    "stbl",
    "size_too_large"
  )
})

test_that("stabilize_dttm() enforces unique elements (#105)", {
  given <- to_dttm(c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z"))
  expect_identical(stabilize_dttm(given, unique = TRUE), given)
  expect_pkg_error_classes(
    stabilize_dttm(
      to_dttm(c("2024-01-01T00:00:00Z", "2024-01-01T00:00:00Z")),
      unique = TRUE
    ),
    "stbl",
    "duplicate_elements"
  )
})

test_that("stabilize_dttm() checks allowed_values (#105)", {
  given <- to_dttm(c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z"))
  expect_identical(
    stabilize_dttm(
      given,
      allowed_values = c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z")
    ),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_dttm(given, allowed_values = "2024-01-01T00:00:00Z"),
    "stbl",
    "allowed_values"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dttm(
      given,
      allowed_values = "2024-01-01T00:00:00Z"
    ),
    "stbl",
    "allowed_values"
  )
})

test_that("stabilize_dttm() rejects date-times without an offset (#105)", {
  expect_pkg_error_snapshot(
    stabilize_dttm("2024-01-01 12:00:00"),
    "stbl",
    "incompatible_values",
    "datetime"
  )
})

test_that("stabilize_dttm() rejects an unrecognized tz (#105)", {
  expect_pkg_error_snapshot(
    stabilize_dttm("2024-01-01T12:00:00Z", tz = "Bogus/Zone"),
    "stbl",
    "bad_tz"
  )
})

test_that("stabilise_dttm() exists (#105)", {
  expect_no_error(stabilise_dttm("2024-01-01T12:00:00Z"))
})

test_that("stabilize_datetime() exists (#105)", {
  expect_no_error(stabilize_datetime("2024-01-01T12:00:00Z"))
})

test_that("stabilise_datetime() exists (#105)", {
  expect_no_error(stabilise_datetime("2024-01-01T12:00:00Z"))
})

test_that("stabilize_dttm_scalar() allows length-1 date-times through (#105)", {
  given <- to_dttm("2024-01-01T12:00:00Z")
  expect_identical(stabilize_dttm_scalar(given), given)
  expect_null(stabilize_dttm_scalar(NULL, allow_null = TRUE))
})

test_that("stabilize_dttm_scalar() respects allow_null (#105)", {
  expect_pkg_error_snapshot(
    stabilize_dttm_scalar(NULL),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dttm_scalar(NULL),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_dttm_scalar() errors on non-scalars (#105)", {
  given <- to_dttm(c("2024-01-01T12:00:00Z", "2024-06-15T00:00:00Z"))
  expect_pkg_error_snapshot(
    stabilize_dttm_scalar(given),
    "stbl",
    "non_scalar"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_dttm_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("stabilize_dttm_scalar() checks allowed_values (#105)", {
  expect_identical(
    stabilize_dttm_scalar(
      "2024-01-01T12:00:00Z",
      allowed_values = c("2024-01-01T12:00:00Z", "2024-06-15T00:00:00Z")
    ),
    to_dttm("2024-01-01T12:00:00Z")
  )
  expect_pkg_error_snapshot(
    stabilize_dttm_scalar(
      "2024-07-01T00:00:00Z",
      allowed_values = "2024-01-01T00:00:00Z"
    ),
    "stbl",
    "allowed_values"
  )
})

test_that("stabilise_dttm_scalar() exists (#105)", {
  expect_no_error(stabilise_dttm_scalar("2024-01-01T12:00:00Z"))
})

test_that("stabilize_datetime_scalar() exists (#105)", {
  expect_no_error(stabilize_datetime_scalar("2024-01-01T12:00:00Z"))
})

test_that("stabilise_datetime_scalar() exists (#105)", {
  expect_no_error(stabilise_datetime_scalar("2024-01-01T12:00:00Z"))
})
