test_that("to_list() works for lists (#157)", {
  given <- list("a", 1L, TRUE)
  expect_identical(to_list(given), given)
})

test_that("to_list() works for NULL (#157)", {
  given <- NULL
  expect_identical(
    to_list(given),
    given
  )
})

test_that("to_list() respects allow_null (#157)", {
  given <- NULL
  expect_error(
    to_list(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_list(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_list(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_list() works for character vectors (#157)", {
  given <- c("a", "b", "c")
  expected <- list("a", "b", "c")
  expect_identical(to_list(given), expected)
})

test_that("to_list() errors by default for functions (#157)", {
  given <- function(x) x + 1
  expect_error(
    to_list(given),
    class = .compile_dash("stbl", "error", "bad_function")
  )
  expect_snapshot(
    to_list(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_list(given),
    error = TRUE
  )
})

test_that("to_list() works for functions with coerce_function = TRUE (#157)", {
  given <- function(x) x + 1
  expected <- as.list(given)
  expect_identical(
    to_list(given, coerce_function = TRUE),
    expected
  )
})

test_that("to_list() errors informatively for primitives (#157)", {
  given <- is.na
  expect_error(
    to_list(given, coerce_function = TRUE),
    class = .compile_dash("stbl", "error", "coerce", "list")
  )
  expect_snapshot(
    to_list(given, coerce_function = TRUE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_list(given, coerce_function = TRUE),
    error = TRUE
  )
})

test_that("to_lst() works for lists (#157)", {
  given <- list("a", 1L, TRUE)
  expect_identical(to_lst(given), to_list(given))
})
