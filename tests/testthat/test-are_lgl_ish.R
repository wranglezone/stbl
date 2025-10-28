test_that("are_lgl_ish() works for logicals (#93)", {
  expect_identical(are_lgl_ish(c(TRUE, FALSE, NA)), rep(TRUE, 3))
})

test_that("are_lgl_ish() works for NULL (#93)", {
  expect_identical(are_lgl_ish(NULL), logical(0))
})

test_that("are_lgl_ish() works for numerics (#93)", {
  expect_identical(are_lgl_ish(c(1, 0, 1.1, NA)), rep(TRUE, 4))
})

test_that("are_lgl_ish() works for characters (#93, #30)", {
  expect_identical(
    are_lgl_ish(c("TRUE", "FALSE", "T", "F", "true", "false", NA)),
    rep(TRUE, 7)
  )
  expect_identical(are_lgl_ish(c("a", "")), c(FALSE, FALSE))
  expect_identical(are_lgl_ish(c("0", "1", "-1", "1.0")), rep(TRUE, 4))
  expect_identical(are_lgl_ish("1.1"), TRUE)
})

test_that("are_lgl_ish() works for factors (#93, #30)", {
  expect_identical(
    are_lgl_ish(factor(c("TRUE", "FALSE", "T", "F", "true", "false", NA))),
    rep(TRUE, 7)
  )
  expect_identical(are_lgl_ish(factor(c("a", ""))), c(FALSE, FALSE))
})

test_that("are_lgl_ish() works for lists (#93, #30)", {
  expect_identical(
    are_lgl_ish(list(TRUE, 1, 0, "false", NA)),
    rep(TRUE, 5)
  )
  expect_identical(
    are_lgl_ish(list("a", NULL, list(1))),
    c(FALSE, FALSE, TRUE)
  )
  expect_identical(
    are_lgl_ish(list("a", NULL, list(1, 0))),
    c(FALSE, FALSE, FALSE)
  )
})

test_that("are_lgl_ish() returns FALSE for non-vectors (#93)", {
  expect_false(are_lgl_ish(mean))
})

test_that("are_lgl_ish() returns FALSE for unhandled S3 objects (#93)", {
  expect_false(is_lgl_ish(Sys.Date()))
  expect_identical(
    are_lgl_ish(as.Date(c("2025-01-01", "2025-01-02"))),
    c(FALSE, FALSE)
  )
  expect_identical(
    are_lgl_ish(list(TRUE, Sys.Date())),
    c(TRUE, FALSE)
  )
})

test_that("is_lgl_ish() works (#93)", {
  expect_true(is_lgl_ish(TRUE))
  expect_true(is_lgl_ish(c(1, 0, NA)))
  expect_true(is_lgl_ish(NULL))
  expect_true(is_lgl_ish(list(TRUE, 0, "false")))

  expect_false(is_lgl_ish("a"))
  expect_false(is_lgl_ish(list(TRUE, "a")))
})
