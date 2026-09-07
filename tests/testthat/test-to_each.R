test_that("to_each() coerces each element with spec and simplifies (#287)", {
  expect_identical(to_each(list("1", "2", "3"), to_int), c(1L, 2L, 3L))
  expect_identical(to_each(list(1L, 2L, 3L), to_chr), c("1", "2", "3"))
})

test_that("to_each() preserves names when simplifying (#287)", {
  expect_identical(
    to_each(list(a = "1", b = "2"), to_int),
    c(a = 1L, b = 2L)
  )
})

test_that("to_each() returns a list when results don't share a common type (#287)", {
  expect_identical(
    to_each(list(1L, "a"), specify_any_of(specify_int(), specify_chr())),
    list(1L, "a")
  )
})

test_that("to_each() returns a list when a result has size != 1 (#287)", {
  duplicate_int <- function(
    x,
    ...,
    x_arg = caller_arg(x),
    call = caller_env()
  ) {
    rep(to_int(x, x_arg = x_arg, call = call), 2)
  }
  expect_identical(
    to_each(list("1", "2"), duplicate_int),
    list(c(1L, 1L), c(2L, 2L))
  )
})

test_that("to_each() returns a list when simplify = FALSE (#287)", {
  expect_identical(
    to_each(list("1", "2"), to_int, simplify = FALSE),
    list(1L, 2L)
  )
})

test_that("to_each() returns x unchanged for zero-length or NULL x (#287)", {
  expect_identical(to_each(NULL, to_int), NULL)
  expect_identical(to_each(list(), to_int), list())
  expect_identical(to_each(character(), to_int), character())
})

test_that("to_each() stops at the first failing element (#287)", {
  expect_pkg_error_snapshot(
    to_each(list("1", "a", "b"), to_int),
    "stbl",
    "incompatible_values",
    "integer"
  )
  expect_pkg_error_snapshot(
    wrapped_to_each(list("1", "a", "b"), to_int),
    "stbl",
    "incompatible_values",
    "integer"
  )
})

test_that("to_each() errors when ... contains extra arguments (#287)", {
  expect_error(
    to_each(list("1"), to_int, extra = TRUE),
    class = "rlib_error_dots_nonempty"
  )
})
