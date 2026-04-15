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

test_that("are_fct_ish() supports max_levels across whole vector (#noissue)", {
  expect_identical(
    are_fct_ish(c("a", "b", "a"), max_levels = 2),
    rep(TRUE, 3)
  )
  expect_identical(
    are_fct_ish(c("a", "b", "c"), max_levels = 2),
    rep(FALSE, 3)
  )
  expect_identical(
    are_fct_ish(
      c("a", "b", "z"),
      levels = c("a", "b"),
      to_na = "z",
      max_levels = 2
    ),
    rep(TRUE, 3)
  )
  expect_identical(
    are_fct_ish(c("a", NA, "b"), max_levels = 1),
    c(FALSE, TRUE, FALSE)
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
  expect_identical(
    .are_not_fct_ish_chr(c("a", NA, "b"), levels = NULL, max_levels = 1),
    c(TRUE, FALSE, TRUE)
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

test_that("is_fct_ish() supports max_levels (#noissue)", {
  expect_true(is_fct_ish(c("a", "b"), max_levels = 2))
  expect_false(is_fct_ish(c("a", "b"), max_levels = 1))
  expect_true(is_fct_ish(c("a", "z"), to_na = "z", max_levels = 1))
})

test_that("are_factor_ish() exists (#164)", {
  expect_no_error(are_factor_ish())
})

test_that("is_factor_ish() exists (#164)", {
  expect_no_error(is_factor_ish("a"))
})
