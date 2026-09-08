test_that("assert_contains() returns x unchanged when enough elements match (#290)", {
  expect_identical(
    assert_contains(list("1", "a", "b"), stabilize_int),
    list("1", "a", "b")
  )
  expect_identical(
    assert_contains(list("1", "2", "a"), stabilize_int, min_matches = 2),
    list("1", "2", "a")
  )
})

test_that("assert_contains() counts every element as a match when spec succeeds outright (#290)", {
  expect_identical(
    assert_contains(c(1L, 2L, 3L), stabilize_int, min_matches = 3),
    c(1L, 2L, 3L)
  )
})

test_that("assert_contains() errors when fewer than min_matches elements match (#290)", {
  expect_pkg_error_snapshot(
    assert_contains(list("a", "b"), stabilize_int),
    "stbl",
    "too_few_matches"
  )
  expect_pkg_error_snapshot(
    wrapped_assert_contains(list("a", "b"), stabilize_int),
    "stbl",
    "too_few_matches"
  )
})

test_that("assert_contains() errors when more than max_matches elements match (#290)", {
  expect_pkg_error_snapshot(
    assert_contains(list("1", "2", "3"), stabilize_int, max_matches = 2),
    "stbl",
    "too_many_matches"
  )
})

test_that("assert_contains() default min_matches is 1 (#290)", {
  expect_identical(
    assert_contains(list("1", "a"), stabilize_int),
    list("1", "a")
  )
  expect_pkg_error_snapshot(
    assert_contains(list("a", "b"), stabilize_int),
    "stbl",
    "too_few_matches"
  )
})

test_that("assert_contains() reports matched locations from a failing spec (#290)", {
  cnd <- rlang::catch_cnd(
    assert_contains(c("1", "a", "3"), stabilize_int, min_matches = 3)
  )
  expect_identical(cnd$locations, c(1L, 3L))
})

test_that("assert_contains() treats all elements as non-matching without locations info (#290)", {
  # stabilize_int_scalar() fails with `non_scalar`, which carries no
  # `locations` element, so no elements can be credited as matches
  expect_pkg_error_snapshot(
    assert_contains(list(1L, 2L), stabilize_int_scalar),
    "stbl",
    "too_few_matches"
  )
})

test_that("assert_contains() works with specify_* functions as spec (#290)", {
  expect_identical(
    assert_contains(list(1L, "a"), specify_int(), min_matches = 1),
    list(1L, "a")
  )
})

test_that("assert_contains() errors when min_matches < 1 (#290)", {
  expect_pkg_error_snapshot(
    assert_contains(list(1L), stabilize_int, min_matches = 0),
    "stbl",
    "outside_range"
  )
})

test_that("assert_contains() errors when max_matches < min_matches (#290)", {
  expect_pkg_error_snapshot(
    assert_contains(list(1L), stabilize_int, min_matches = 2, max_matches = 1),
    "stbl",
    "outside_range"
  )
})

test_that("assert_contains() errors when ... contains extra arguments (#290)", {
  expect_error(assert_contains(list(1L), stabilize_int, extra = TRUE))
})

test_that("assert_contains() composes with stabilize_all_of() (#290)", {
  has_int <- function(x, ...) {
    assert_contains(x, stabilize_int, ...)
  }
  expect_identical(
    stabilize_all_of("1", stabilize_chr, has_int),
    "1"
  )
  expect_pkg_error_snapshot(
    stabilize_all_of("a", stabilize_chr, has_int),
    "stbl",
    "cant_stabilize_all_of"
  )
})
