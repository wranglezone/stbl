test_that("resolve_tz() returns the local time zone by default (#370)", {
  withr::local_timezone("America/Chicago")
  expect_identical(resolve_tz(), "America/Chicago")
  withr::local_timezone("Asia/Tokyo")
  expect_identical(resolve_tz(), "Asia/Tokyo")
})

test_that("resolve_tz() uses the tzone of x when it has one (#370)", {
  withr::local_timezone("America/Chicago")
  x <- as.POSIXct("2024-01-01 12:00:00", tz = "Europe/Paris")
  expect_identical(resolve_tz(x), "Europe/Paris")
  expect_identical(resolve_tz(x, default = "UTC"), "Europe/Paris")
})

test_that("resolve_tz() uses the first element of a 3-element tzone (#370)", {
  x <- as.POSIXct("2024-01-01 12:00:00", tz = "America/Chicago")
  attr(x, "tzone") <- c("America/Chicago", "CST", "CDT")
  expect_identical(resolve_tz(x), "America/Chicago")
})

test_that("resolve_tz() falls back to default when x has no usable tzone (#370)", {
  withr::local_timezone("Asia/Tokyo")
  no_tzone <- as.POSIXct("2024-01-01 12:00:00")
  attr(no_tzone, "tzone") <- NULL
  empty_tzone <- no_tzone
  attr(empty_tzone, "tzone") <- ""
  zero_length_tzone <- no_tzone
  attr(zero_length_tzone, "tzone") <- character()
  # Not a POSIXct, because printing a POSIXct with an NA tzone warns.
  na_tzone <- structure(0, tzone = NA_character_)
  for (x in list(NULL, 1, no_tzone, empty_tzone, zero_length_tzone, na_tzone)) {
    expect_identical(resolve_tz(x), "Asia/Tokyo")
    expect_identical(resolve_tz(x, default = "UTC"), "UTC")
  }
})

test_that("resolve_tz() resolves an empty default to the local time zone (#370)", {
  withr::local_timezone("America/Chicago")
  expect_identical(resolve_tz(default = ""), "America/Chicago")
})

test_that("resolve_tz() errors when the time zone can't be determined (#370)", {
  expect_pkg_error_snapshot(
    resolve_tz(default = NA_character_),
    "stbl",
    "bad_tz"
  )
})

test_that("resolve_tz() errors for an unrecognized tzone on x (#370)", {
  x <- as.POSIXct("2024-01-01 12:00:00")
  attr(x, "tzone") <- "this is not a timezone"
  expect_pkg_error_snapshot(resolve_tz(x), "stbl", "bad_tz")
})

test_that(".check_tz() rejects an unrecognized local time zone (#370)", {
  withr::local_timezone("Not/A_Zone")
  expect_pkg_error_snapshot(.check_tz(""), "stbl", "bad_tz")
})
