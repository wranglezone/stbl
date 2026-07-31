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
  expect_pkg_error_snapshot(
    to_lst(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_to_lst(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("to_lst() rejects unused dots for methods that ignore them (#200)", {
  expect_error(
    to_lst(list(a = 1L), new_arg = "red"),
    class = "rlib_error_dots_nonempty"
  )
  expect_error(
    to_lst(NULL, new_arg = "red"),
    class = "rlib_error_dots_nonempty"
  )
  expect_error(
    to_lst(function(x) x, coerce_function = TRUE, new_arg = "red"),
    class = "rlib_error_dots_nonempty"
  )
  expect_snapshot(
    to_lst(list(a = 1L), new_arg = "red"),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lst(list(a = 1L), new_arg = "red"),
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
  expect_pkg_error_snapshot(to_lst(given), "stbl", "bad_function")
  expect_pkg_error_snapshot(wrapped_to_lst(given), "stbl", "bad_function")
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
  expect_pkg_error_snapshot(
    to_lst(given, coerce_function = TRUE),
    "stbl",
    "coerce",
    "list"
  )
  expect_pkg_error_snapshot(
    wrapped_to_lst(given, coerce_function = TRUE),
    "stbl",
    "coerce",
    "list"
  )
})

test_that("to_list() exists (#157, #166)", {
  expect_no_error(to_list(TRUE))
})
