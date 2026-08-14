test_that("stabilize_date() coerces and returns dates (#104)", {
  given <- c("2024-01-01", "2024-06-15")
  expect_identical(stabilize_date(given), as.Date(given))
})

test_that("stabilize_date() works for NULL (#104)", {
  expect_null(stabilize_date(NULL))
  expect_pkg_error_snapshot(
    stabilize_date(NULL, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_date() respects allow_na (#104)", {
  given <- as.Date(c("2024-01-01", NA))
  expect_identical(stabilize_date(given), given)
  expect_pkg_error_snapshot(
    stabilize_date(given, allow_na = FALSE),
    "stbl",
    "bad_na"
  )
})

test_that("stabilize_date() checks min_value (#104)", {
  given <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_identical(
    stabilize_date(given, min_value = "2024-01-01", max_value = "2024-12-31"),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_date(given, min_value = "2024-06-01"),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_date(given, min_value = "2024-06-01"),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_date() checks max_value (#104)", {
  given <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_pkg_error_snapshot(
    stabilize_date(given, max_value = "2024-03-01"),
    "stbl",
    "outside_range"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_date(given, max_value = "2024-03-01"),
    "stbl",
    "outside_range"
  )
})

test_that("stabilize_date() attaches value failure locations (#104)", {
  cnd <- rlang::catch_cnd(stabilize_date(
    as.Date(c("2024-01-01", "2024-07-01", "2024-02-01")),
    min_value = "2024-06-01"
  ))
  expect_identical(cnd$locations, c(1L, 3L))
})

test_that("stabilize_date() checks size (#104)", {
  given <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_pkg_error_snapshot(
    stabilize_date(given, min_size = 3),
    "stbl",
    "size_too_small"
  )
  expect_pkg_error_snapshot(
    stabilize_date(given, max_size = 1),
    "stbl",
    "size_too_large"
  )
})

test_that("stabilize_date() enforces unique elements (#104)", {
  given <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_identical(stabilize_date(given, unique = TRUE), given)
  expect_pkg_error_classes(
    stabilize_date(
      as.Date(c("2024-01-01", "2024-01-01")),
      unique = TRUE
    ),
    "stbl",
    "duplicate_elements"
  )
})

test_that("stabilize_date() checks allowed_values (#104)", {
  given <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_identical(
    stabilize_date(given, allowed_values = c("2024-01-01", "2024-06-15")),
    given
  )
  expect_pkg_error_snapshot(
    stabilize_date(given, allowed_values = "2024-01-01"),
    "stbl",
    "allowed_values"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_date(given, allowed_values = "2024-01-01"),
    "stbl",
    "allowed_values"
  )
})

test_that("stabilize_date() rejects ambiguous formats (#104)", {
  expect_pkg_error_snapshot(
    stabilize_date("11/13/2018"),
    "stbl",
    "incompatible_values",
    "date"
  )
})

test_that("stabilise_date() exists (#104)", {
  expect_no_error(stabilise_date("2024-01-01"))
})

test_that("stabilize_date_scalar() allows length-1 dates through (#104)", {
  given <- as.Date("2024-01-01")
  expect_identical(stabilize_date_scalar(given), given)
  expect_null(stabilize_date_scalar(NULL, allow_null = TRUE))
})

test_that("stabilize_date_scalar() respects allow_null (#104)", {
  expect_pkg_error_snapshot(
    stabilize_date_scalar(NULL),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_date_scalar(NULL),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_date_scalar() errors on non-scalars (#104)", {
  given <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_pkg_error_snapshot(
    stabilize_date_scalar(given),
    "stbl",
    "non_scalar"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_date_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("stabilize_date_scalar() checks allowed_values (#104)", {
  expect_identical(
    stabilize_date_scalar(
      "2024-01-01",
      allowed_values = c("2024-01-01", "2024-06-15")
    ),
    as.Date("2024-01-01")
  )
  expect_pkg_error_snapshot(
    stabilize_date_scalar("2024-07-01", allowed_values = "2024-01-01"),
    "stbl",
    "allowed_values"
  )
})

test_that("stabilise_date_scalar() exists (#104)", {
  expect_no_error(stabilise_date_scalar("2024-01-01"))
})
