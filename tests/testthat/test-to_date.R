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

test_that("to_date() rejects ambiguous date formats (#104, #377)", {
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

test_that("to_date() rejects unparseable date strings (#104, #377)", {
  given <- c("2024-01-01", "not-a-date")
  expect_pkg_error_snapshot(
    to_date(given),
    "stbl",
    "incompatible_values",
    "date"
  )
})

test_that("to_date() rejects impossible dates (#104, #377)", {
  expect_pkg_error_snapshot(
    to_date("2024-02-30"),
    "stbl",
    "incompatible_values",
    "date"
  )
})

test_that("to_date() converts factors via the character path (#104)", {
  given <- factor(c("2024-01-01", "2024-06-15"))
  expected <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_identical(to_date(given), expected)
})

test_that("to_date() errors informatively for bad factors (#104, #377)", {
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

test_that("to_date() errors properly for other types (#104, #369)", {
  given <- as.raw(1:10)
  expect_pkg_error_classes(to_date(given), "stbl", "coerce", "date")
})

test_that("to_date_scalar() allows length-1 dates through (#104)", {
  given <- as.Date("2024-01-01")
  expect_identical(to_date_scalar(given), given)
})

test_that("to_date_scalar() converts length-1 input (#104)", {
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

test_that("to_date() treat_number_as = 'days' is the default (#381)", {
  expect_identical(
    to_date(19723, treat_number_as = "days"),
    as.Date("2024-01-01")
  )
  expect_identical(to_date(19723L), to_date(19723L, treat_number_as = "days"))
  expect_identical(to_date(c(0, NA)), as.Date(c("1970-01-01", NA)))
})

test_that("to_date() treat_number_as = 'seconds' uses the UTC date (#381)", {
  expected <- as.Date("2024-01-01")
  expect_identical(to_date(1704110400, treat_number_as = "seconds"), expected)
  expect_identical(to_date(1704110400L, treat_number_as = "seconds"), expected)
  expect_identical(
    to_date(c(1704110400, NA), treat_number_as = "seconds"),
    as.Date(c("2024-01-01", NA))
  )
  # Floors to the date, including for negative values.
  expect_identical(
    to_date(c(86399.9, 86400, -0.5), treat_number_as = "seconds"),
    as.Date(c("1970-01-01", "1970-01-02", "1969-12-31"))
  )
})

test_that("to_date() treat_number_as = 'milliseconds' uses the UTC date (#381)", {
  expected <- as.Date("2024-01-01")
  expect_identical(
    to_date(1704110400000, treat_number_as = "milliseconds"),
    expected
  )
  expect_identical(
    to_date(c(1704110400123, NA), treat_number_as = "milliseconds"),
    as.Date(c("2024-01-01", NA))
  )
  expect_identical(
    to_date(86399999L, treat_number_as = "milliseconds"),
    as.Date("1970-01-01")
  )
})

test_that("to_date() treat_number_as = 'error' rejects numbers (#381)", {
  expect_pkg_error_classes(
    to_date(1, treat_number_as = "error"),
    "stbl",
    "coerce",
    "date"
  )
  expect_pkg_error_classes(
    to_date(1L, treat_number_as = "error"),
    "stbl",
    "coerce",
    "date"
  )
  expect_pkg_error_classes(
    to_date(NA_real_, treat_number_as = "error"),
    "stbl",
    "coerce",
    "date"
  )
})

test_that("to_date() validates treat_number_as (#381)", {
  expect_error(to_date(1, treat_number_as = "bogus"), class = "rlang_error")
})

test_that("to_date() ignores treat_number_as for non-numbers (#381)", {
  expected <- as.Date("2024-01-01")
  expect_identical(to_date("2024-01-01", treat_number_as = "error"), expected)
  expect_identical(to_date(expected, treat_number_as = "error"), expected)
  expect_identical(
    to_date(factor("2024-01-01"), treat_number_as = "error"),
    expected
  )
  expect_identical(
    to_date(
      as.POSIXct("2024-01-01 12:00:00", tz = "UTC"),
      treat_number_as = "error"
    ),
    expected
  )
})

test_that("treat_number_as passes through to_date_scalar() and to() (#381)", {
  expected <- as.Date("2024-01-01")
  expect_identical(
    to_date_scalar(1704110400000, treat_number_as = "milliseconds"),
    expected
  )
  expect_identical(
    to(1704110400, expected, treat_number_as = "seconds"),
    expected
  )
  expect_pkg_error_classes(
    to_date_scalar(1, treat_number_as = "error"),
    "stbl",
    "coerce",
    "date"
  )
})

test_that("to_date() uses tz for seconds and milliseconds (#381)", {
  # Midnight UTC on 2024-01-01.
  secs <- 1704067200
  expect_identical(
    to_date(secs, treat_number_as = "seconds"),
    as.Date("2024-01-01")
  )
  expect_identical(
    to_date(secs, tz = "America/Los_Angeles", treat_number_as = "seconds"),
    as.Date("2023-12-31")
  )
  expect_identical(
    to_date(
      secs * 1000,
      tz = "Pacific/Auckland",
      treat_number_as = "milliseconds"
    ),
    as.Date("2024-01-01")
  )
  expect_identical(
    to_date(
      secs * 1000,
      tz = "America/Los_Angeles",
      treat_number_as = "milliseconds"
    ),
    as.Date("2023-12-31")
  )
})

test_that("to_date() tz doesn't change days (#381)", {
  expect_identical(
    to_date(19723, tz = "America/Los_Angeles"),
    as.Date("2024-01-01")
  )
})

test_that("to_date() converts POSIXct to tz before truncating (#381)", {
  # 22:00 on Jan 1 in New York is already Jan 2 in UTC.
  given <- as.POSIXct("2024-01-01 22:00:00", tz = "America/New_York")
  expect_identical(to_date(given), as.Date("2024-01-02"))
  expect_identical(
    to_date(given, tz = "America/New_York"),
    as.Date("2024-01-01")
  )
  expect_identical(
    to_date(given, tz = "Pacific/Auckland"),
    as.Date("2024-01-02")
  )
  expect_identical(to_date(c(given, NA)), as.Date(c("2024-01-02", NA)))
})

test_that("to_date() numbers match equivalent POSIXct input (#381)", {
  given <- as.POSIXct("2024-01-01 22:00:00", tz = "America/New_York")
  tz <- "America/New_York"
  expect_identical(
    to_date(as.numeric(given), tz = tz, treat_number_as = "seconds"),
    to_date(given, tz = tz)
  )
  expect_identical(
    to_date(
      as.numeric(given) * 1000,
      tz = tz,
      treat_number_as = "milliseconds"
    ),
    to_date(given, tz = tz)
  )
})

test_that("to_date() validates tz for epoch numbers (#381)", {
  expect_pkg_error_classes(
    to_date(1, tz = "not/a_tz", treat_number_as = "seconds"),
    "stbl",
    "bad_tz"
  )
})

test_that("tz passes through to_date_scalar() and to() (#381)", {
  expect_identical(
    to_date_scalar(
      1704067200,
      tz = "America/Los_Angeles",
      treat_number_as = "seconds"
    ),
    as.Date("2023-12-31")
  )
  expect_identical(
    to(
      1704067200,
      as.Date("2024-01-01"),
      tz = "America/Los_Angeles",
      treat_number_as = "seconds"
    ),
    as.Date("2023-12-31")
  )
})
