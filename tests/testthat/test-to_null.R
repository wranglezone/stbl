test_that(".to_null() works on the happy path (#129)", {
  expect_null(.to_null(NULL))
})

test_that(".to_null() errors when NULL isn't allowed (#129)", {
  given <- NULL
  expect_pkg_error_classes(
    .to_null(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_snapshot(
    .to_null(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_null(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that(".to_null() coerces anything to NULL (#129)", {
  expect_null(.to_null(1L))
  expect_null(.to_null(mean))
  expect_null(.to_null(TRUE))
  expect_null(.to_null(letters))
})

test_that(".to_null() errors for bad allow_null (#129)", {
  expect_pkg_error_classes(
    .to_null(NULL, allow_null = NULL),
    "stbl",
    "bad_null"
  )
  expect_snapshot(
    .to_null(NULL, allow_null = NULL),
    error = TRUE
  )

  expect_pkg_error_classes(
    .to_null(NULL, allow_null = "fish"),
    "stbl",
    "incompatible_type"
  )
  expect_snapshot(
    .to_null(NULL, allow_null = "fish"),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_null(NULL, allow_null = "fish"),
    error = TRUE
  )
})

test_that(".to_null() errors informatively for missing value (#129)", {
  expect_pkg_error_classes(.to_null(), "stbl", "must")
  expect_snapshot(
    .to_null(),
    error = TRUE
  )
})
