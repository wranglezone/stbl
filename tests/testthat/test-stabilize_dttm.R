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

test_that("stabilize_dttm() accepts locale-dependent date orders (#326)", {
  expect_identical(
    stabilize_dttm(
      "11/13/2018 08:00:00",
      accepted_datetime_formats = locale_datetime_formats("en_US.UTF-8")
    ),
    as.POSIXct("2018-11-13 08:00:00", tz = "UTC")
  )
})

test_that("stabilize_dttm() treats a missing offset as wall-clock time in tz (#326)", {
  expect_identical(
    stabilize_dttm("2024-01-01 12:00:00", tz = "America/Chicago"),
    as.POSIXct("2024-01-01 12:00:00", tz = "America/Chicago")
  )
})

test_that("stabilize_dttm() still uses an explicit offset when present (#326)", {
  expect_identical(
    stabilize_dttm("2024-01-01 12:00:00-05:00"),
    as.POSIXct("2024-01-01 17:00:00", tz = "UTC")
  )
})

test_that("stabilize_dttm() requires one format to work for every element (#326)", {
  expect_pkg_error_classes(
    stabilize_dttm(
      c("2024-01-01 00:00:00", "11/13/2018 08:00:00"),
      accepted_datetime_formats = locale_datetime_formats("en_US.UTF-8")
    ),
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

test_that(".format_to_capture_regex() tracks field order (#326)", {
  parts <- .format_to_capture_regex("%m/%d/%Y")
  expect_equal(parts$regex, "(\\d{2})/(\\d{2})/(\\d{4})")
  expect_equal(parts$fields, c("m", "d", "Y"))
})

test_that(".format_to_capture_regex() handles all specifiers and reordering (#326)", {
  parts <- .format_to_capture_regex("%Y-%m-%d %H:%M:%S")
  expect_equal(
    parts$regex,
    "(\\d{4})-(\\d{2})-(\\d{2}) (\\d{2}):(\\d{2}):(\\d{2})"
  )
  expect_equal(parts$fields, c("Y", "m", "d", "H", "M", "S"))
})

test_that(".try_dttm_formats() returns early when the first format succeeds (#326)", {
  result <- .try_dttm_formats(
    c(
      "2024-01-01T12:00:00Z",
      "2024-01-01T12:00:00+05:00",
      "2024-01-01T12:00:00"
    ),
    "%Y-%m-%dT%H:%M:%S",
    tz = "UTC"
  )
  expect_equal(
    result$parsed,
    as.POSIXct(
      c("2024-01-01 12:00:00", "2024-01-01 07:00:00", "2024-01-01 12:00:00"),
      tz = "UTC"
    )
  )
  expect_equal(result$failures, c(FALSE, FALSE, FALSE))
})

test_that(".try_dttm_formats() falls back to a later format (#326)", {
  result <- .try_dttm_formats(
    c("2024-01-01", "2024-01-02"),
    c("%Y-%m-%dT%H:%M:%S", "%Y-%m-%d"),
    tz = "UTC"
  )
  expect_equal(
    result$parsed,
    as.POSIXct(c("2024-01-01", "2024-01-02"), tz = "UTC")
  )
  expect_equal(result$failures, c(FALSE, FALSE))
})

test_that(".try_dttm_formats() treats a missing offset as wall-clock time in tz (#326)", {
  result <- .try_dttm_formats(
    "2024-01-01T12:00:00",
    "%Y-%m-%dT%H:%M:%S",
    tz = "America/Chicago"
  )
  expect_equal(
    result$parsed,
    as.POSIXct("2024-01-01 12:00:00", tz = "America/Chicago")
  )
  expect_false(result$failures)
})

test_that(".try_dttm_formats() skips elements that are NA or the wrong shape (#326)", {
  result <- .try_dttm_formats(
    c(NA_character_, "not-a-date"),
    "%Y-%m-%dT%H:%M:%S",
    tz = "UTC"
  )
  expect_true(all(is.na(result$parsed)))
  expect_equal(result$failures, c(FALSE, TRUE))
})

test_that(".try_dttm_formats() returns the first format's result when none succeed (#326)", {
  result <- .try_dttm_formats(
    "2024-02-30T12:00:00",
    "%Y-%m-%dT%H:%M:%S",
    tz = "UTC"
  )
  expect_true(is.na(result$parsed))
  expect_true(result$failures)
})

test_that(".parse_dttm_matches() defaults missing time fields to midnight (#326)", {
  parts <- .format_to_capture_regex("%Y-%m-%d")
  pattern <- paste0("^", parts$regex, "(Z|z|[+-]\\d{2}:\\d{2})?$")
  x <- c("2024-01-01", "2024-06-15")
  matches <- regmatches(x, regexec(pattern, x))
  parsed <- .parse_dttm_matches(matches, parts$fields, tz = "UTC")
  expect_equal(parsed, as.POSIXct(c("2024-01-01", "2024-06-15"), tz = "UTC"))
})

test_that(".parse_dttm_matches() returns NA for calendar-invalid dates (#326)", {
  parts <- .format_to_capture_regex("%Y-%m-%dT%H:%M:%S")
  pattern <- paste0("^", parts$regex, "(Z|z|[+-]\\d{2}:\\d{2})?$")
  x <- "2024-02-30T12:00:00"
  matches <- regmatches(x, regexec(pattern, x))
  parsed <- .parse_dttm_matches(matches, parts$fields, tz = "UTC")
  expect_true(is.na(parsed))
})

test_that(".parse_dttm_matches() applies an explicit UTC offset (#326)", {
  parts <- .format_to_capture_regex("%Y-%m-%dT%H:%M:%S")
  pattern <- paste0("^", parts$regex, "(Z|z|[+-]\\d{2}:\\d{2})?$")
  x <- "2024-01-01T12:00:00+05:00"
  matches <- regmatches(x, regexec(pattern, x))
  parsed <- .parse_dttm_matches(matches, parts$fields, tz = "UTC")
  expect_equal(parsed, as.POSIXct("2024-01-01 07:00:00", tz = "UTC"))
})

test_that("stabilize_dttm() resolves an empty tz to the local time zone (#370)", {
  withr::local_timezone("America/Chicago")
  result <- stabilize_dttm("2024-01-01 12:00:00", tz = "")
  expect_identical(attr(result, "tzone"), "America/Chicago")
  expect_identical(
    result,
    as.POSIXct("2024-01-01 12:00:00", tz = "America/Chicago")
  )
})

test_that("specify_dttm() resolves an empty tz to the local time zone (#370)", {
  withr::local_timezone("Asia/Tokyo")
  result <- specify_dttm(tz = "")("2024-01-01T12:00:00Z")
  expect_identical(attr(result, "tzone"), "Asia/Tokyo")
})
