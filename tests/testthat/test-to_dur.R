test_that("to_dur() passes Period through (#295)", {
  given <- lubridate::period(year = 1, month = 2, day = 3)
  expect_identical(to_dur(given), given)
})

test_that("to_dur() works for NULL (#295)", {
  given <- NULL
  expect_identical(to_dur(given), given)
})

test_that("to_dur() respects allow_null (#295)", {
  given <- NULL
  expect_pkg_error_snapshot(
    to_dur(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_to_dur(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("to_dur() parses the full RFC 3339 date/time form (#295)", {
  expect_identical(
    to_dur("P3Y6M4DT12H30M5S"),
    .new_period_vec(3, 6, 4, 12, 30, 5)
  )
})

test_that("to_dur() parses date-only durations (#295)", {
  expect_identical(to_dur("P1Y"), .new_period_vec(1, 0, 0, 0, 0, 0))
  expect_identical(to_dur("P1M"), .new_period_vec(0, 1, 0, 0, 0, 0))
  expect_identical(to_dur("P1D"), .new_period_vec(0, 0, 1, 0, 0, 0))
  expect_identical(to_dur("P1Y2M3D"), .new_period_vec(1, 2, 3, 0, 0, 0))
})

test_that("to_dur() parses time-only durations (#295)", {
  expect_identical(to_dur("PT1H"), .new_period_vec(0, 0, 0, 1, 0, 0))
  expect_identical(to_dur("PT1M"), .new_period_vec(0, 0, 0, 0, 1, 0))
  expect_identical(to_dur("PT1S"), .new_period_vec(0, 0, 0, 0, 0, 1))
  expect_identical(to_dur("P23DT23H"), .new_period_vec(0, 0, 23, 23, 0, 0))
})

test_that("to_dur() parses the week form (#295)", {
  expect_identical(to_dur("P4W"), .new_period_vec(0, 0, 28, 0, 0, 0))
  expect_identical(to_dur("P0W"), .new_period_vec(0, 0, 0, 0, 0, 0))
})

test_that("to_dur() parses zero-length durations (#295)", {
  expect_identical(to_dur("P0D"), .new_period_vec(0, 0, 0, 0, 0, 0))
  expect_identical(to_dur("PT0S"), .new_period_vec(0, 0, 0, 0, 0, 0))
})

test_that("to_dur() keeps NA character elements as NA (#295)", {
  given <- c("P1D", NA)
  result <- to_dur(given)
  expect_identical(is.na(result), c(FALSE, TRUE))
})

test_that("to_dur() rejects a bare P or PT (#295)", {
  expect_pkg_error_snapshot(
    to_dur("P"),
    "stbl",
    "incompatible_values",
    "duration"
  )
  expect_pkg_error_snapshot(
    to_dur("PT"),
    "stbl",
    "incompatible_values",
    "duration"
  )
})

test_that("to_dur() rejects mixing the week form with other units (#295)", {
  expect_pkg_error_snapshot(
    to_dur("P1W2D"),
    "stbl",
    "incompatible_values",
    "duration"
  )
})

test_that("to_dur() rejects fractional components (#295)", {
  expect_pkg_error_snapshot(
    to_dur("P1.5D"),
    "stbl",
    "incompatible_values",
    "duration"
  )
})

test_that("to_dur() rejects a negative sign (#295)", {
  expect_pkg_error_snapshot(
    to_dur("-P1D"),
    "stbl",
    "incompatible_values",
    "duration"
  )
})

test_that("to_dur() rejects out-of-order components (#295)", {
  expect_pkg_error_snapshot(
    to_dur("P1D1Y"),
    "stbl",
    "incompatible_values",
    "duration"
  )
})

test_that("to_dur() rejects lowercase durations (#295)", {
  expect_pkg_error_snapshot(
    to_dur("p1y2m"),
    "stbl",
    "incompatible_values",
    "duration"
  )
})

test_that("to_dur() rejects unparseable duration strings (#295)", {
  given <- c("P1D", "not-a-duration")
  expect_pkg_error_snapshot(
    to_dur(given),
    "stbl",
    "incompatible_values",
    "duration"
  )
  expect_pkg_error_snapshot(
    wrapped_to_dur(given),
    "stbl",
    "incompatible_values",
    "duration"
  )
})

test_that("to_dur() coerces factors via the character path (#295)", {
  given <- factor(c("P1D", "P2D"))
  expected <- to_dur(as.character(given))
  expect_identical(to_dur(given), expected)
})

test_that("to_dur() errors informatively for bad factors (#295)", {
  given <- factor(c("P1D", "nope"))
  expect_pkg_error_snapshot(
    to_dur(given),
    "stbl",
    "incompatible_values",
    "duration"
  )
})

test_that("to_dur() converts difftime values, preserving their unit (#295)", {
  expect_identical(
    to_dur(as.difftime(90, units = "mins")),
    lubridate::as.period(as.difftime(90, units = "mins"))
  )
  expect_identical(
    to_dur(as.difftime(2, units = "days")),
    lubridate::as.period(as.difftime(2, units = "days"))
  )
})

test_that("to_dur() converts hms values via the difftime path (#295)", {
  given <- hms::hms(0, 20, 13)
  expect_identical(to_dur(given), lubridate::as.period(given))
})

test_that("to_dur() treats numerics as seconds (#295)", {
  expect_identical(to_dur(3661), lubridate::seconds_to_period(3661))
  expect_identical(to_dur(3661L), lubridate::seconds_to_period(3661))
})

test_that("to_dur() errors properly for other types (#295)", {
  given <- as.raw(1:10)
  expect_error(to_dur(given), class = "vctrs_error_cast")
})

test_that("to_dur_scalar() allows length-1 durations through (#295)", {
  given <- lubridate::period(day = 1)
  expect_identical(to_dur_scalar(given), given)
})

test_that("to_dur_scalar() coerces length-1 input (#295)", {
  expect_identical(to_dur_scalar("P1D"), to_dur("P1D"))
})

test_that("to_dur_scalar() provides informative error messages (#295)", {
  given <- c("P1D", "P2D")
  expect_pkg_error_snapshot(to_dur_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    wrapped_to_dur_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("to_dur_scalar() respects allow_null (#295)", {
  given <- NULL
  expect_pkg_error_snapshot(to_dur_scalar(given), "stbl", "bad_null")
  expect_pkg_error_snapshot(
    wrapped_to_dur_scalar(given),
    "stbl",
    "bad_null"
  )
})

test_that("to_dur_scalar() respects allow_zero_length (#295)", {
  given <- to_dur(character())
  expect_pkg_error_snapshot(to_dur_scalar(given), "stbl", "bad_empty")
})
