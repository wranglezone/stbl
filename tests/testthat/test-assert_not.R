test_that("assert_not() returns x unchanged when spec fails (#289)", {
  expect_identical(assert_not("a", specify_int()), "a")
  expect_identical(assert_not(1.5, stabilize_int), 1.5)
})

test_that("assert_not() errors when spec succeeds outright (#289)", {
  expect_pkg_error_snapshot(
    assert_not(1L, stabilize_int),
    "stbl",
    "matched_spec"
  )
})

test_that("assert_not() works with to_* functions as spec (#289)", {
  expect_identical(assert_not("a", to_int), "a")
  expect_pkg_error_snapshot(assert_not("1", to_int), "stbl", "matched_spec")
})

test_that("assert_not() errors when ... contains extra arguments (#289)", {
  expect_error(assert_not("a", specify_int(), extra = TRUE))
})

test_that("assert_not() composes with stabilize_all_of() (#289)", {
  # x must be a character, and must not equal "1"
  not_one <- function(x, ...) {
    assert_not(x, specify_chr(allowed_values = "1"), ...)
  }
  expect_identical(
    stabilize_all_of("2", stabilize_chr, not_one),
    "2"
  )
  expect_pkg_error_snapshot(
    stabilize_all_of("1", stabilize_chr, not_one),
    "stbl",
    "cant_stabilize_all_of"
  )
})
