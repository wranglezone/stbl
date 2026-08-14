test_that("specify_dttm can build a value checker (#105, #325)", {
  checker <- specify_dttm(min_value = "2000-01-01T00:00:00Z")
  expect_identical(
    checker("2024-01-01T00:00:00Z"),
    to_dttm("2024-01-01T00:00:00Z")
  )
  expect_pkg_error_classes(
    checker("1999-12-31T00:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dttm can enforce unique elements (#105, #325)", {
  checker <- specify_dttm(unique = TRUE)
  given <- to_dttm(c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z"))
  expect_identical(checker(given), given)
  expect_pkg_error_classes(
    checker(to_dttm(c("2024-01-01T00:00:00Z", "2024-01-01T00:00:00Z"))),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_dttm respects tz (#105, #325)", {
  checker <- specify_dttm(tz = "America/Chicago")
  result <- checker("2024-01-01T00:00:00Z")
  expect_identical(attr(result, "tzone"), "America/Chicago")
})

test_that("specify_dttm_scalar can build a value checker (#105, #325)", {
  checker <- specify_dttm_scalar(min_value = "2000-01-01T00:00:00Z")
  expect_identical(
    checker("2024-01-01T00:00:00Z"),
    to_dttm("2024-01-01T00:00:00Z")
  )
  expect_pkg_error_classes(
    checker(to_dttm(c(
      "2024-01-01T00:00:00Z",
      "2024-06-15T00:00:00Z"
    ))),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_dttm_scalar defaults to allow_null = FALSE (#105, #325)", {
  checker <- specify_dttm_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_dttm_scalar defaults to allow_zero_length = FALSE (#105, #325)", {
  checker <- specify_dttm_scalar()
  empty <- to_dttm(character())
  expect_pkg_error_classes(checker(empty), "stbl", "bad_empty")
  expect_identical(
    checker(empty, allow_zero_length = TRUE),
    empty
  )
})

test_that("specify_dttm can enforce allowed_values (#105, #325)", {
  checker <- specify_dttm(
    allowed_values = c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z")
  )
  expect_identical(
    checker("2024-01-01T00:00:00Z"),
    to_dttm("2024-01-01T00:00:00Z")
  )
  expect_pkg_error_classes(
    checker("2024-07-01T00:00:00Z"),
    "stbl",
    "allowed_values"
  )
})

test_that("specify_dttm() creates a working stabilizer (#105, #325)", {
  stabilize_recent <- specify_dttm(min_value = "2000-01-01T00:00:00Z")
  expect_identical(
    stabilize_recent("2024-01-01T00:00:00Z"),
    to_dttm("2024-01-01T00:00:00Z")
  )
  expect_pkg_error_classes(
    stabilize_recent("1999-12-31T00:00:00Z"),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dttm_scalar() creates a working scalar stabilizer (#105, #325)", {
  stabilize_recent <- specify_dttm_scalar(
    min_value = "2000-01-01T00:00:00Z"
  )
  expect_identical(
    stabilize_recent("2024-01-01T00:00:00Z"),
    to_dttm("2024-01-01T00:00:00Z")
  )
  expect_pkg_error_classes(
    stabilize_recent(c("2024-01-01T00:00:00Z", "2024-06-15T00:00:00Z")),
    "stbl",
    "non_scalar"
  )
})
