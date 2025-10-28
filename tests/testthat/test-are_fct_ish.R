test_that("are_fct_ish() is TRUE for atomics when levels is NULL (#93)", {
  expect_true(is_fct_ish(letters))
  expect_true(is_fct_ish(factor(letters)))
  expect_true(is_fct_ish(1:10))
  expect_true(is_fct_ish(c(TRUE, FALSE)))
})

test_that("are_fct_ish() works for NULL (#93)", {
  expect_identical(are_fct_ish(NULL), logical(0))
})

test_that("are_fct_ish() works when levels are provided (#93)", {
  expect_identical(
    are_fct_ish(letters[1:3], levels = c("a", "b", "c")),
    rep(TRUE, 3)
  )
  expect_identical(
    are_fct_ish(letters[1:3], levels = c("a", "b")),
    c(TRUE, TRUE, FALSE)
  )
  expect_identical(
    are_fct_ish(1:3, levels = c("1", "2")),
    c(TRUE, TRUE, FALSE)
  )
})

test_that("are_fct_ish() works with to_na (#93)", {
  expect_identical(
    are_fct_ish(letters[1:3], levels = "a", to_na = c("b", "c")),
    rep(TRUE, 3)
  )
})

test_that(".are_not_fct_ish_chr() works (#93)", {
  expect_identical(
    .are_not_fct_ish_chr(letters[1:3], levels = c("a", "b")),
    c(FALSE, FALSE, TRUE)
  )
  expect_identical(
    .are_not_fct_ish_chr(letters[1:3], levels = "a", to_na = c("b", "c")),
    rep(FALSE, 3)
  )
  expect_identical(
    .are_not_fct_ish_chr(letters, levels = NULL),
    rep(FALSE, 26)
  )
})

test_that("are_fct_ish() works for lists (#93)", {
  expect_identical(
    are_fct_ish(list("a", 1, TRUE), levels = c("a", "1", "TRUE")),
    rep(TRUE, 3)
  )
  expect_identical(
    are_fct_ish(list("a", NULL, list(1)), levels = "a"),
    c(TRUE, FALSE, FALSE)
  )
})

test_that("are_fct_ish() returns FALSE for non-vectors (#93)", {
  expect_false(are_fct_ish(mean))
})

test_that("are_fct_ish() deals with factor-ish S3 objects (#93)", {
  expect_true(is_fct_ish(Sys.Date()))
})

test_that("is_fct_ish() works (#93)", {
  expect_true(is_fct_ish(letters))
  expect_true(is_fct_ish(NULL))
  expect_false(is_fct_ish(letters, levels = "a"))
})
