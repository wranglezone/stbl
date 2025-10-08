test_that(".to_null() works on the happy path", {
  expect_null(.to_null(NULL))
})

test_that(".to_null() errors when NULL isn't allowed", {
  given <- NULL
  expect_error(
    .to_null(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
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

test_that(".to_null() coerces anything to NULL", {
  expect_null(.to_null(1L))
  expect_null(.to_null(mean))
  expect_null(.to_null(TRUE))
  expect_null(.to_null(letters))
})

test_that(".to_null() errors for bad allow_null", {
  expect_error(
    .to_null(NULL, allow_null = NULL),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    .to_null(NULL, allow_null = NULL),
    error = TRUE
  )

  expect_error(
    .to_null(NULL, allow_null = "fish"),
    class = .compile_dash("stbl", "error", "incompatible_type")
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

test_that(".to_null() errors informatively for missing value", {
  expect_error(
    .to_null(),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    .to_null(),
    error = TRUE
  )
})
