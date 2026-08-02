test_that(".to_null() works on the happy path (#129)", {
  expect_null(.to_null(NULL))
})

test_that(".to_null() errors when NULL isn't allowed (#129)", {
  given <- NULL
  expect_pkg_error_snapshot(
    .to_null(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_to_null(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that(".to_null() coerces anything to NULL (#129)", {
  expect_null(.to_null(1L))
  expect_null(.to_null(mean))
  expect_null(.to_null(TRUE))
  expect_null(.to_null(letters))
})

test_that(".to_null() errors for bad allow_null (#129, wranglezone/stbl#310)", {
  expect_pkg_error_snapshot(
    .to_null(NULL, allow_null = NULL),
    "stbl",
    "bad_null"
  )

  expect_pkg_error_snapshot(
    .to_null(NULL, allow_null = "fish"),
    "stbl",
    "incompatible_values", "logical"
  )
  expect_pkg_error_snapshot(
    wrapped_to_null(NULL, allow_null = "fish"),
    "stbl",
    "incompatible_values", "logical"
  )
})

test_that(".to_null() errors informatively for missing value (#129)", {
  expect_pkg_error_snapshot(.to_null(), "stbl", "must")
})
