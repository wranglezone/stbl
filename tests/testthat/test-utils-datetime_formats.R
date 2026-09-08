test_that(".format_to_regex() converts specifiers to a shape-checking regex", {
  regex <- .format_to_regex("%Y-%m-%d")
  expect_equal(regex, "^\\d{4}-\\d{2}-\\d{2}$")
  expect_true(grepl(regex, "2024-01-01"))
  # Trailing characters aren't part of the shape, so they should fail.
  expect_false(grepl(regex, "2024-01-01T12:00:00"))
})

test_that(".format_to_regex() handles all supported specifiers", {
  regex <- .format_to_regex("%Y-%m-%d %H:%M:%S")
  expect_equal(regex, "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}$")
  expect_true(grepl(regex, "2024-01-01 12:30:45"))
  expect_false(grepl(regex, "2024-01-01 12:30"))
})

test_that(".format_to_capture_regex() tracks field order", {
  parts <- .format_to_capture_regex("%m/%d/%Y")
  expect_equal(parts$regex, "(\\d{2})/(\\d{2})/(\\d{4})")
  expect_equal(parts$fields, c("m", "d", "Y"))
})

test_that(".format_to_capture_regex() handles all specifiers and reordering", {
  parts <- .format_to_capture_regex("%Y-%m-%d %H:%M:%S")
  expect_equal(
    parts$regex,
    "(\\d{4})-(\\d{2})-(\\d{2}) (\\d{2}):(\\d{2}):(\\d{2})"
  )
  expect_equal(parts$fields, c("Y", "m", "d", "H", "M", "S"))
})

test_that(".try_date_formats() returns early when the first format succeeds", {
  result <- .try_date_formats(
    c("2024-01-01", "2024-01-02"),
    c("%Y-%m-%d", "%m/%d/%Y")
  )
  expect_equal(result$parsed, as.Date(c("2024-01-01", "2024-01-02")))
  expect_equal(result$failures, c(FALSE, FALSE))
})

test_that(".try_date_formats() falls back to a later format", {
  result <- .try_date_formats(
    c("01/02/2024", "03/04/2024"),
    c("%Y-%m-%d", "%m/%d/%Y")
  )
  expect_equal(result$parsed, as.Date(c("2024-01-02", "2024-03-04")))
  expect_equal(result$failures, c(FALSE, FALSE))
})

test_that(".try_date_formats() returns the first format's result when none succeed", {
  result <- .try_date_formats(
    c("13/01/2024", "2024-02-30"),
    c("%d/%m/%Y", "%Y-%m-%d")
  )
  expect_equal(result$parsed, as.Date(c("2024-01-13", NA)))
  expect_equal(result$failures, c(FALSE, TRUE))
})

test_that(".try_date_formats() skips NA elements", {
  result <- .try_date_formats(c(NA_character_, NA_character_), c("%Y-%m-%d"))
  expect_true(all(is.na(result$parsed)))
  expect_equal(result$failures, c(FALSE, FALSE))
})

test_that(".try_dttm_formats() returns early when the first format succeeds", {
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

test_that(".try_dttm_formats() falls back to a later format", {
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

test_that(".try_dttm_formats() treats a missing offset as wall-clock time in tz", {
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

test_that(".try_dttm_formats() skips elements that are NA or the wrong shape", {
  result <- .try_dttm_formats(
    c(NA_character_, "not-a-date"),
    "%Y-%m-%dT%H:%M:%S",
    tz = "UTC"
  )
  expect_true(all(is.na(result$parsed)))
  expect_equal(result$failures, c(FALSE, TRUE))
})

test_that(".try_dttm_formats() returns the first format's result when none succeed", {
  result <- .try_dttm_formats(
    "2024-02-30T12:00:00",
    "%Y-%m-%dT%H:%M:%S",
    tz = "UTC"
  )
  expect_true(is.na(result$parsed))
  expect_true(result$failures)
})

test_that(".parse_dttm_matches() defaults missing time fields to midnight", {
  parts <- .format_to_capture_regex("%Y-%m-%d")
  pattern <- paste0("^", parts$regex, "(Z|z|[+-]\\d{2}:\\d{2})?$")
  x <- c("2024-01-01", "2024-06-15")
  matches <- regmatches(x, regexec(pattern, x))
  parsed <- .parse_dttm_matches(matches, parts$fields, tz = "UTC")
  expect_equal(parsed, as.POSIXct(c("2024-01-01", "2024-06-15"), tz = "UTC"))
})

test_that(".parse_dttm_matches() returns NA for calendar-invalid dates", {
  parts <- .format_to_capture_regex("%Y-%m-%dT%H:%M:%S")
  pattern <- paste0("^", parts$regex, "(Z|z|[+-]\\d{2}:\\d{2})?$")
  x <- "2024-02-30T12:00:00"
  matches <- regmatches(x, regexec(pattern, x))
  parsed <- .parse_dttm_matches(matches, parts$fields, tz = "UTC")
  expect_true(is.na(parsed))
})

test_that(".parse_dttm_matches() applies an explicit UTC offset", {
  parts <- .format_to_capture_regex("%Y-%m-%dT%H:%M:%S")
  pattern <- paste0("^", parts$regex, "(Z|z|[+-]\\d{2}:\\d{2})?$")
  x <- "2024-01-01T12:00:00+05:00"
  matches <- regmatches(x, regexec(pattern, x))
  parsed <- .parse_dttm_matches(matches, parts$fields, tz = "UTC")
  expect_equal(parsed, as.POSIXct("2024-01-01 07:00:00", tz = "UTC"))
})
