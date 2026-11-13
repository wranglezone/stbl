test_that("specify_date can build a value checker (#104, #325)", {
  checker <- specify_date(min_value = "2000-01-01")
  expect_identical(checker("2024-01-01"), as.Date("2024-01-01"))
  expect_pkg_error_classes(
    checker("1999-12-31"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_date can enforce unique elements (#104, #325)", {
  checker <- specify_date(unique = TRUE)
  given <- as.Date(c("2024-01-01", "2024-06-15"))
  expect_identical(checker(given), given)
  expect_pkg_error_classes(
    checker(as.Date(c("2024-01-01", "2024-01-01"))),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_date_scalar can build a value checker (#104, #325)", {
  checker <- specify_date_scalar(min_value = "2000-01-01")
  expect_identical(checker("2024-01-01"), as.Date("2024-01-01"))
  expect_pkg_error_classes(
    checker(as.Date(c("2024-01-01", "2024-06-15"))),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_date_scalar defaults to allow_null = FALSE (#104, #325)", {
  checker <- specify_date_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_date_scalar defaults to allow_zero_length = FALSE (#104, #325)", {
  checker <- specify_date_scalar()
  expect_pkg_error_classes(
    checker(as.Date(character(0))),
    "stbl",
    "bad_empty"
  )
  expect_identical(
    checker(as.Date(character(0)), allow_zero_length = TRUE),
    as.Date(character(0))
  )
})

test_that("specify_date can enforce allowed_values (#104, #325)", {
  checker <- specify_date(allowed_values = c("2024-01-01", "2024-06-15"))
  expect_identical(checker("2024-01-01"), as.Date("2024-01-01"))
  expect_pkg_error_classes(checker("2024-07-01"), "stbl", "allowed_values")
})

test_that("specify_date can set accepted_datetime_formats (#326)", {
  checker <- specify_date(
    accepted_datetime_formats = locale_datetime_formats("en_GB.UTF-8")
  )
  expect_identical(checker("13/11/2018"), as.Date("2018-11-13"))
})

test_that("specify_date() creates a working stabilizer (#104, #325)", {
  stabilize_recent <- specify_date(min_value = "2000-01-01")
  expect_identical(stabilize_recent("2024-01-01"), as.Date("2024-01-01"))
  expect_pkg_error_classes(
    stabilize_recent("1999-12-31"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_date_scalar() creates a working scalar stabilizer (#104, #325)", {
  stabilize_recent <- specify_date_scalar(min_value = "2000-01-01")
  expect_identical(stabilize_recent("2024-01-01"), as.Date("2024-01-01"))
  expect_pkg_error_classes(
    stabilize_recent(c("2024-01-01", "2024-06-15")),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_date() can set treat_number_as (#381)", {
  expected <- as.Date("2024-01-01")
  checker <- specify_date(treat_number_as = "seconds")
  expect_identical(checker(1704110400), expected)
  strict <- specify_date(treat_number_as = "error")
  expect_pkg_error_classes(strict(1), "stbl", "coerce", "date")
  expect_identical(strict("2024-01-01"), expected)
})

test_that("specify_date_scalar() can set treat_number_as (#381)", {
  expected <- as.Date("2024-01-01")
  checker <- specify_date_scalar(treat_number_as = "milliseconds")
  expect_identical(checker(1704110400000), expected)
  strict <- specify_date_scalar(treat_number_as = "error")
  expect_pkg_error_classes(strict(1), "stbl", "coerce", "date")
})

test_that("specify_date*() can set tz (#381)", {
  expected <- as.Date("2023-12-31")
  checker <- specify_date(
    tz = "America/Los_Angeles",
    treat_number_as = "seconds"
  )
  expect_identical(checker(1704067200), expected)
  checker_scalar <- specify_date_scalar(
    tz = "America/Los_Angeles",
    treat_number_as = "seconds"
  )
  expect_identical(checker_scalar(1704067200), expected)
})

test_that("specify_date() and specify_date_scalar() error for unnamed or unknown arguments (#402)", {
  expect_dot_errors(specify_date)
  expect_dot_errors(specify_date_scalar)
})
