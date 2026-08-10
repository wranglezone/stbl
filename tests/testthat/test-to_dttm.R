test_that("to_dttm() normalizes POSIXct to the target tz (#105)", {
  given <- as.POSIXct("2024-01-01 12:00:00", tz = "UTC")
  expect_identical(to_dttm(given), given)
  result <- to_dttm(given, tz = "America/Chicago")
  expect_identical(attr(result, "tzone"), "America/Chicago")
  expect_identical(as.numeric(result), as.numeric(given))
})

test_that("to_dttm() works for NULL (#105)", {
  given <- NULL
  expect_identical(to_dttm(given), given)
})

test_that("to_dttm() respects allow_null (#105)", {
  given <- NULL
  expect_pkg_error_snapshot(
    to_dttm(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_to_dttm(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("to_dttm() parses RFC 3339 date-time strings with Z (#105)", {
  given <- c("2024-01-01T12:00:00Z", "2024-06-15T00:00:00Z")
  expected <- as.POSIXct(given, format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  expect_identical(to_dttm(given), expected)
})

test_that("to_dttm() parses numeric UTC offsets (#105)", {
  expect_identical(
    to_dttm("2024-01-01T12:00:00-05:00"),
    as.POSIXct("2024-01-01 17:00:00", tz = "UTC")
  )
  expect_identical(
    to_dttm("2024-01-01T12:00:00+05:30"),
    as.POSIXct("2024-01-01 06:30:00", tz = "UTC")
  )
})

test_that("to_dttm() allows a space instead of T (#105)", {
  expect_identical(
    to_dttm("2024-01-01 12:00:00Z"),
    as.POSIXct("2024-01-01 12:00:00", tz = "UTC")
  )
})

test_that("to_dttm() parses fractional seconds (#105)", {
  result <- to_dttm("2024-01-01T12:00:00.5Z")
  expect_identical(
    as.numeric(result),
    as.numeric(as.POSIXct(
      "2024-01-01 12:00:00",
      tz = "UTC"
    )) +
      0.5
  )
})

test_that("to_dttm() normalizes to the requested tz (#105)", {
  result <- to_dttm("2024-01-01T12:00:00Z", tz = "America/Chicago")
  expect_identical(attr(result, "tzone"), "America/Chicago")
  expect_identical(
    as.numeric(result),
    as.numeric(as.POSIXct("2024-01-01 12:00:00", tz = "UTC"))
  )
})

test_that("to_dttm() keeps NA character elements as NA (#105)", {
  given <- c("2024-01-01T12:00:00Z", NA)
  result <- to_dttm(given)
  expect_identical(is.na(result), c(FALSE, TRUE))
})

test_that("to_dttm() rejects date-times without an offset (#105)", {
  expect_pkg_error_snapshot(
    to_dttm("2024-01-01 12:00:00"),
    "stbl",
    "incompatible_values",
    "datetime"
  )
  expect_pkg_error_snapshot(
    wrapped_to_dttm("2024-01-01 12:00:00"),
    "stbl",
    "incompatible_values",
    "datetime"
  )
})

test_that("to_dttm() rejects unparseable date-time strings (#105)", {
  given <- c("2024-01-01T12:00:00Z", "not-a-datetime")
  expect_pkg_error_snapshot(
    to_dttm(given),
    "stbl",
    "incompatible_values",
    "datetime"
  )
})

test_that("to_dttm() rejects impossible date-times (#105)", {
  expect_pkg_error_snapshot(
    to_dttm("2024-02-30T12:00:00Z"),
    "stbl",
    "incompatible_values",
    "datetime"
  )
  expect_pkg_error_snapshot(
    to_dttm("2024-01-01T25:00:00Z"),
    "stbl",
    "incompatible_values",
    "datetime"
  )
})

test_that("to_dttm() rejects an unrecognized tz (#105)", {
  expect_pkg_error_snapshot(
    to_dttm("2024-01-01T12:00:00Z", tz = "Bogus/Zone"),
    "stbl",
    "bad_tz"
  )
})

test_that("to_dttm() coerces factors via the character path (#105)", {
  given <- factor(c("2024-01-01T12:00:00Z", "2024-06-15T00:00:00Z"))
  expected <- to_dttm(as.character(given))
  expect_identical(to_dttm(given), expected)
})

test_that("to_dttm() errors informatively for bad factors (#105)", {
  given <- factor(c("2024-01-01T12:00:00Z", "nope"))
  expect_pkg_error_snapshot(
    to_dttm(given),
    "stbl",
    "incompatible_values",
    "datetime"
  )
})

test_that("to_dttm() converts POSIXlt (#105)", {
  given <- as.POSIXlt("2024-01-01 12:00:00", tz = "UTC")
  expect_identical(
    to_dttm(given),
    as.POSIXct("2024-01-01 12:00:00", tz = "UTC")
  )
})

test_that("to_dttm() treats Date as midnight UTC (#105)", {
  given <- as.Date("2024-01-01")
  expect_identical(
    to_dttm(given),
    as.POSIXct("2024-01-01 00:00:00", tz = "UTC")
  )
})

test_that("to_dttm() treats numerics as seconds since the epoch (#105)", {
  expect_identical(to_dttm(0), as.POSIXct("1970-01-01 00:00:00", tz = "UTC"))
  expect_identical(to_dttm(0L), as.POSIXct("1970-01-01 00:00:00", tz = "UTC"))
})

test_that("to_dttm() errors properly for other types (#105)", {
  given <- as.raw(1:10)
  expect_error(to_dttm(given), class = "vctrs_error_cast")
})

test_that("to_dttm_scalar() allows length-1 date-times through (#105)", {
  given <- as.POSIXct("2024-01-01 12:00:00", tz = "UTC")
  expect_identical(to_dttm_scalar(given), given)
})

test_that("to_dttm_scalar() coerces length-1 input (#105)", {
  expect_identical(
    to_dttm_scalar("2024-01-01T12:00:00Z"),
    as.POSIXct("2024-01-01 12:00:00", tz = "UTC")
  )
})

test_that("to_dttm_scalar() provides informative error messages (#105)", {
  given <- c("2024-01-01T12:00:00Z", "2024-06-15T00:00:00Z")
  expect_pkg_error_snapshot(to_dttm_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    wrapped_to_dttm_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("to_dttm_scalar() respects allow_null (#105)", {
  given <- NULL
  expect_pkg_error_snapshot(to_dttm_scalar(given), "stbl", "bad_null")
  expect_pkg_error_snapshot(
    wrapped_to_dttm_scalar(given),
    "stbl",
    "bad_null"
  )
})

test_that("to_dttm_scalar() respects allow_zero_length (#105)", {
  given <- as.POSIXct(character(), tz = "UTC")
  expect_pkg_error_snapshot(to_dttm_scalar(given), "stbl", "bad_empty")
})
