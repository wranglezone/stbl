test_that("specify_time can build a value checker (#294, #325)", {
  checker <- specify_time(min_value = "12:00:00Z")
  expect_identical(checker("13:00:00Z"), to_time("13:00:00Z"))
  expect_pkg_error_classes(
    checker("06:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_time can enforce unique elements (#294, #325)", {
  checker <- specify_time(unique = TRUE)
  given <- to_time(c("06:00:00Z", "14:00:00Z"))
  expect_identical(checker(given), given)
  expect_pkg_error_classes(
    checker(to_time(c("06:00:00Z", "06:00:00Z"))),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_time_scalar can build a value checker (#294, #325)", {
  checker <- specify_time_scalar(min_value = "12:00:00Z")
  expect_identical(checker("13:00:00Z"), to_time("13:00:00Z"))
  expect_pkg_error_classes(
    checker(to_time(c("13:00:00Z", "14:00:00Z"))),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_time_scalar defaults to allow_null = FALSE (#294, #325)", {
  checker <- specify_time_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_time_scalar defaults to allow_zero_length = FALSE (#294, #325)", {
  checker <- specify_time_scalar()
  empty <- to_time(character())
  expect_pkg_error_classes(checker(empty), "stbl", "bad_empty")
  expect_identical(checker(empty, allow_zero_length = TRUE), empty)
})

test_that("specify_time can enforce allowed_values (#294, #325)", {
  checker <- specify_time(
    allowed_values = c("06:00:00Z", "14:00:00Z")
  )
  expect_identical(checker("06:00:00Z"), to_time("06:00:00Z"))
  expect_pkg_error_classes(checker("09:00:00Z"), "stbl", "allowed_values")
})

test_that("specify_time() creates a working stabilizer (#294, #325)", {
  stabilize_afternoon <- specify_time(min_value = "12:00:00Z")
  expect_identical(
    stabilize_afternoon("13:00:00Z"),
    to_time("13:00:00Z")
  )
  expect_pkg_error_classes(
    stabilize_afternoon("06:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_time_scalar() creates a working scalar stabilizer (#294, #325)", {
  stabilize_afternoon <- specify_time_scalar(min_value = "12:00:00Z")
  expect_identical(
    stabilize_afternoon("13:00:00Z"),
    to_time("13:00:00Z")
  )
  expect_pkg_error_classes(
    stabilize_afternoon(c("13:00:00Z", "14:00:00Z")),
    "stbl",
    "non_scalar"
  )
})
