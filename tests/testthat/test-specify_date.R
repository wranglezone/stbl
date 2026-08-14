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
