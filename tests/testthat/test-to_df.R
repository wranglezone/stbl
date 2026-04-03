test_that("to_df() returns a data frame unchanged (#199)", {
  expect_identical(to_df(mtcars), mtcars)
})

test_that("to_df() returns NULL for NULL input by default (#199)", {
  expect_null(to_df(NULL))
})

test_that("to_df() respects allow_null (#199)", {
  expect_error(
    to_df(NULL, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_df(NULL, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_df(NULL, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_df() coerces a named list to a data frame (#199)", {
  given <- list(name = "Alice", age = 30L)
  result <- to_df(given)
  expect_s3_class(result, "data.frame")
  expect_identical(result$name, "Alice")
  expect_identical(result$age, 30L)
})

test_that("to_df() coerces a list of equal-length vectors to a data frame (#199)", {
  given <- list(x = 1:3, y = letters[1:3])
  result <- to_df(given)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3L)
  expect_identical(result$x, 1:3)
  expect_identical(result$y, letters[1:3])
})

test_that("to_df() errors for a list with incompatible column lengths (#199)", {
  expect_error(
    to_df(list(a = 1:3, b = 1:2)),
    class = .compile_dash("stbl", "error", "coerce", "data.frame")
  )
  expect_snapshot(
    to_df(list(a = 1:3, b = 1:2)),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_df(list(a = 1:3, b = 1:2)),
    error = TRUE
  )
})

test_that("to_df() errors for non-coercible types (#199)", {
  expect_error(
    to_df("not a data frame"),
    class = .compile_dash("stbl", "error", "coerce", "data.frame")
  )
  expect_snapshot(
    to_df("not a data frame"),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_df("not a data frame"),
    error = TRUE
  )
})

test_that("to_data_frame() exists (#199)", {
  expect_identical(to_data_frame(mtcars), mtcars)
})
