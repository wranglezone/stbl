test_that("to_date() passes Dates through (#104)", {
  given <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_identical(to_date(given), given)
})

test_that("to_date() works for NULL (#104)", {
  given <- NULL
  expect_identical(to_date(given), given)
})

test_that("to_date() respects allow_null (#104)", {
  given <- NULL
  expect_pkg_error_snapshot(
    to_date(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_to_date(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("to_date() parses RFC 3339 full-date strings (#104)", {
  given <- c("2024-01-01", "2024-06-15")
  expected <- as.Date(given)
  expect_identical(to_date(given), expected)
})

test_that("to_date() keeps NA character elements as NA (#104)", {
  given <- c("2024-01-01", NA)
  expected <- as.Date(c("2024-01-01", NA))
  expect_identical(to_date(given), expected)
})

test_that("to_date() rejects ambiguous date formats (#104)", {
  expect_pkg_error_snapshot(
    to_date("11/13/2018"),
    "stbl",
    "incompatible_values",
    "date"
  )
  expect_pkg_error_snapshot(
    wrapped_to_date("11/13/2018"),
    "stbl",
    "incompatible_values",
    "date"
  )
})

test_that("to_date() rejects unparseable date strings (#104)", {
  given <- c("2024-01-01", "not-a-date")
  expect_pkg_error_snapshot(
    to_date(given),
    "stbl",
    "incompatible_values",
    "date"
  )
})

test_that("to_date() rejects impossible dates (#104)", {
  expect_pkg_error_snapshot(
    to_date("2024-02-30"),
    "stbl",
    "incompatible_values",
    "date"
  )
})

test_that("to_date() coerces factors via the character path (#104)", {
  given <- factor(c("2024-01-01", "2024-06-15"))
  expected <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_identical(to_date(given), expected)
})

test_that("to_date() errors informatively for bad factors (#104)", {
  given <- factor(c("2024-01-01", "nope"))
  expect_pkg_error_snapshot(
    to_date(given),
    "stbl",
    "incompatible_values",
    "date"
  )
})

test_that("to_date() truncates POSIXct to the date component (#104)", {
  given <- as.POSIXct("2024-01-01 23:30:00", tz = "UTC")
  expect_identical(to_date(given), as.Date("2024-01-01"))
})

test_that("to_date() truncates POSIXlt to the date component (#104)", {
  given <- as.POSIXlt("2024-01-01 23:30:00", tz = "UTC")
  expect_identical(to_date(given), as.Date("2024-01-01"))
})

test_that("to_date() treats numerics as days since the epoch (#104)", {
  expect_identical(to_date(0), as.Date("1970-01-01"))
  expect_identical(to_date(0L), as.Date("1970-01-01"))
  expect_identical(to_date(19723L), as.Date("2024-01-01"))
})

test_that("to_date() errors properly for other types (#104)", {
  given <- as.raw(1:10)
  expect_error(to_date(given), class = "vctrs_error_cast")
})

test_that("to_date_scalar() allows length-1 dates through (#104)", {
  given <- as.Date("2024-01-01")
  expect_identical(to_date_scalar(given), given)
})

test_that("to_date_scalar() coerces length-1 input (#104)", {
  expect_identical(to_date_scalar("2024-01-01"), as.Date("2024-01-01"))
})

test_that("to_date_scalar() provides informative error messages (#104)", {
  given <- c("2024-01-01", "2024-06-15")
  expect_pkg_error_snapshot(to_date_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    wrapped_to_date_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("to_date_scalar() respects allow_null (#104)", {
  given <- NULL
  expect_pkg_error_snapshot(to_date_scalar(given), "stbl", "bad_null")
  expect_pkg_error_snapshot(
    wrapped_to_date_scalar(given),
    "stbl",
    "bad_null"
  )
})

test_that("to_date_scalar() respects allow_zero_length (#104)", {
  given <- as.Date(character())
  expect_pkg_error_snapshot(to_date_scalar(given), "stbl", "bad_empty")
})
