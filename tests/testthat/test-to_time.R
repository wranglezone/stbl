test_that("to_time() passes hms through (#294)", {
  given <- hms::hms(0, 20, 13)
  expect_identical(to_time(given), given)
})

test_that("to_time() works for NULL (#294)", {
  given <- NULL
  expect_identical(to_time(given), given)
})

test_that("to_time() respects allow_null (#294)", {
  given <- NULL
  expect_pkg_error_snapshot(
    to_time(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_to_time(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("to_time() parses RFC 3339 full-time strings with Z (#294)", {
  given <- c("13:20:00Z", "00:00:00Z")
  expected <- hms::as_hms(c("13:20:00", "00:00:00"))
  expect_identical(to_time(given), expected)
})

test_that("to_time() normalizes numeric offsets to UTC (#294)", {
  expect_identical(to_time("13:20:00-05:00"), hms::as_hms("18:20:00"))
  expect_identical(to_time("13:20:00+05:30"), hms::as_hms("07:50:00"))
})

test_that("to_time() wraps offsets across midnight (#294)", {
  expect_identical(to_time("23:30:00-01:00"), hms::as_hms("00:30:00"))
  expect_identical(to_time("00:30:00+01:00"), hms::as_hms("23:30:00"))
})

test_that("to_time() parses fractional seconds (#294)", {
  result <- to_time("13:20:00.5Z")
  expect_identical(
    as.numeric(result),
    as.numeric(hms::as_hms("13:20:00")) + 0.5
  )
})

test_that("to_time() keeps NA character elements as NA (#294)", {
  given <- c("13:20:00Z", NA)
  result <- to_time(given)
  expect_identical(is.na(result), c(FALSE, TRUE))
})

test_that("to_time() rejects times without an offset (#294)", {
  expect_pkg_error_snapshot(
    to_time("13:20:00"),
    "stbl",
    "incompatible_values",
    "time"
  )
  expect_pkg_error_snapshot(
    wrapped_to_time("13:20:00"),
    "stbl",
    "incompatible_values",
    "time"
  )
})

test_that("to_time() rejects unparseable time strings (#294)", {
  given <- c("13:20:00Z", "not-a-time")
  expect_pkg_error_snapshot(
    to_time(given),
    "stbl",
    "incompatible_values",
    "time"
  )
})

test_that("to_time() rejects impossible times (#294)", {
  expect_pkg_error_snapshot(
    to_time("25:00:00Z"),
    "stbl",
    "incompatible_values",
    "time"
  )
  expect_pkg_error_snapshot(
    to_time("13:60:00Z"),
    "stbl",
    "incompatible_values",
    "time"
  )
})

test_that("to_time() coerces factors via the character path (#294)", {
  given <- factor(c("13:20:00Z", "14:20:00Z"))
  expected <- to_time(as.character(given))
  expect_identical(to_time(given), expected)
})

test_that("to_time() errors informatively for bad factors (#294)", {
  given <- factor(c("13:20:00Z", "nope"))
  expect_pkg_error_snapshot(
    to_time(given),
    "stbl",
    "incompatible_values",
    "time"
  )
})

test_that("to_time() extracts time-of-day from POSIXct, normalized to UTC (#294)", {
  given <- as.POSIXct("2024-01-01 13:20:00", tz = "America/Chicago")
  expect_identical(
    to_time(given),
    to_time(as.POSIXct(format(given, tz = "UTC"), tz = "UTC"))
  )
})

test_that("to_time() converts POSIXlt (#294)", {
  given <- as.POSIXlt("2024-01-01 13:20:00", tz = "UTC")
  expect_identical(to_time(given), hms::as_hms("13:20:00"))
})

test_that("to_time() treats numerics as seconds since midnight (#294)", {
  expect_identical(to_time(3600), hms::as_hms("01:00:00"))
  expect_identical(to_time(3600L), hms::as_hms("01:00:00"))
})

test_that("to_time() rejects out-of-range numerics (#294)", {
  expect_pkg_error_snapshot(to_time(-1), "stbl", "incompatible_values", "time")
  expect_pkg_error_snapshot(
    to_time(86400),
    "stbl",
    "incompatible_values",
    "time"
  )
})

test_that("to_time() converts difftime values (#294)", {
  given <- as.difftime(1.5, units = "hours")
  expect_identical(to_time(given), hms::as_hms("01:30:00"))
})

test_that("to_time() rejects out-of-range difftime values (#294)", {
  given <- as.difftime(25, units = "hours")
  expect_pkg_error_snapshot(
    to_time(given),
    "stbl",
    "incompatible_values",
    "time"
  )
})

test_that("to_time() rejects out-of-range hms values (#294)", {
  given <- hms::as_hms(90000)
  expect_pkg_error_snapshot(
    to_time(given),
    "stbl",
    "incompatible_values",
    "time"
  )
})

test_that("to_time() errors properly for other types (#294)", {
  given <- as.raw(1:10)
  expect_error(to_time(given), class = "vctrs_error_cast")
})

test_that("to_time_scalar() allows length-1 times through (#294)", {
  given <- hms::hms(0, 20, 13)
  expect_identical(to_time_scalar(given), given)
})

test_that("to_time_scalar() coerces length-1 input (#294)", {
  expect_identical(to_time_scalar("13:20:00Z"), hms::as_hms("13:20:00"))
})

test_that("to_time_scalar() provides informative error messages (#294)", {
  given <- c("13:20:00Z", "14:20:00Z")
  expect_pkg_error_snapshot(to_time_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    wrapped_to_time_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("to_time_scalar() respects allow_null (#294)", {
  given <- NULL
  expect_pkg_error_snapshot(to_time_scalar(given), "stbl", "bad_null")
  expect_pkg_error_snapshot(
    wrapped_to_time_scalar(given),
    "stbl",
    "bad_null"
  )
})

test_that("to_time_scalar() respects allow_zero_length (#294)", {
  given <- hms::as_hms(character())
  expect_pkg_error_snapshot(to_time_scalar(given), "stbl", "bad_empty")
})
