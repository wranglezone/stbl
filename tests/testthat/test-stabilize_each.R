test_that("stabilize_each() coerces each element with spec and simplifies (#287)", {
  expect_identical(
    stabilize_each(list("1", "2", "3"), stabilize_int),
    c(1L, 2L, 3L)
  )
  expect_identical(
    stabilize_each(list(1L, 2L, 3L), stabilize_chr),
    c("1", "2", "3")
  )
})

test_that("stabilize_each() preserves names when simplifying (#287)", {
  expect_identical(
    stabilize_each(list(a = "1", b = "2"), stabilize_int),
    c(a = 1L, b = 2L)
  )
})

test_that("stabilize_each() returns a list when results don't share a common type (#287)", {
  expect_identical(
    stabilize_each(list(1L, "a"), specify_any_of(specify_int(), specify_chr())),
    list(1L, "a")
  )
})

test_that("stabilize_each() returns a list when simplify = FALSE (#287)", {
  expect_identical(
    stabilize_each(list("1", "2"), stabilize_int, simplify = FALSE),
    list(1L, 2L)
  )
})

test_that("stabilize_each() returns x unchanged for zero-length or NULL x (#287)", {
  expect_identical(stabilize_each(NULL, stabilize_int), NULL)
  expect_identical(stabilize_each(list(), stabilize_int), list())
  expect_identical(stabilize_each(character(), stabilize_int), character())
})

test_that("stabilize_each() reports every failing location at once (#287)", {
  cnd <- rlang::catch_cnd(stabilize_each(list("1", "a", "b"), stabilize_int))
  expect_identical(cnd$locations, c(2L, 3L))
})

test_that("stabilize_each() errors with a combined message for all failures (#287)", {
  expect_pkg_error_snapshot(
    stabilize_each(list("1", "a", "b"), stabilize_int),
    "stbl",
    "cant_stabilize_each"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_each(list("1", "a", "b"), stabilize_int),
    "stbl",
    "cant_stabilize_each"
  )
})

test_that("stabilize_each() errors when ... contains extra arguments (#287)", {
  expect_error(
    stabilize_each(list("1"), stabilize_int, extra = TRUE),
    class = "rlib_error_dots_nonempty"
  )
})

test_that("stabilise_each() is a synonym for stabilize_each() (#287)", {
  expect_identical(stabilise_each, stabilize_each)
})
