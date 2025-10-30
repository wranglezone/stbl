test_that("to_lst() works for lists (#157, #166)", {
  given <- list("a", 1L, TRUE)
  expect_identical(to_lst(given), given)
})

test_that("to_lst() works for NULL (#157)", {
  given <- NULL
  expect_identical(
    to_lst(given),
    given
  )
})

test_that("to_lst() respects allow_null (#157)", {
  given <- NULL
  expect_error(
    to_lst(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_lst(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lst(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_lst() works for character vectors (#157)", {
  given <- c("a", "b", "c")
  expected <- list("a", "b", "c")
  expect_identical(to_lst(given), expected)
})

test_that("to_lst() errors by default for functions (#157)", {
  given <- function(x) x + 1
  expect_error(
    to_lst(given),
    class = .compile_dash("stbl", "error", "bad_function")
  )
  expect_snapshot(
    to_lst(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lst(given),
    error = TRUE
  )
})

test_that("to_lst() works for functions with coerce_function = TRUE (#157)", {
  given <- function(x) x + 1
  expected <- as.list(given)
  expect_identical(
    to_lst(given, coerce_function = TRUE),
    expected
  )
})

test_that("to_lst() errors informatively for primitives (#157)", {
  given <- is.na
  expect_error(
    to_lst(given, coerce_function = TRUE),
    class = .compile_dash("stbl", "error", "coerce", "list")
  )
  expect_snapshot(
    to_lst(given, coerce_function = TRUE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lst(given, coerce_function = TRUE),
    error = TRUE
  )
})

test_that("to_list() exists (#157, #166)", {
  expect_no_error(to_list(TRUE))
})
