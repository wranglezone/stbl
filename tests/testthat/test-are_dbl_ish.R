test_that("are_dbl_ish() works for dbls (#23)", {
  expect_identical(
    are_dbl_ish(c(1.0, 2.1, NA, Inf, -Inf)),
    rep(TRUE, 5)
  )
})

test_that("are_dbl_ish() works for ints (#23)", {
  expect_identical(are_dbl_ish(1:10), rep(TRUE, 10))
})

test_that("are_dbl_ish() works for NULL (#23)", {
  expect_identical(are_dbl_ish(NULL), logical(0))
})

test_that("are_dbl_ish() works for logicals (#23)", {
  expect_identical(are_dbl_ish(c(TRUE, FALSE, NA)), rep(TRUE, 3))
})

test_that("are_dbl_ish() works for characters (#23)", {
  expect_identical(
    are_dbl_ish(c("1", "2.0", "Inf", NA)),
    c(TRUE, TRUE, TRUE, TRUE)
  )
  expect_identical(
    are_dbl_ish(c("a", "")),
    c(FALSE, FALSE)
  )
})

test_that("are_dbl_ish() respects coerce_character (#23)", {
  expect_identical(
    are_dbl_ish(c("1", "2.0"), coerce_character = TRUE),
    c(TRUE, TRUE)
  )
  expect_identical(
    are_dbl_ish(c("1", "2.0"), coerce_character = FALSE),
    c(FALSE, FALSE)
  )
})

test_that("are_dbl_ish() works for factors (#23)", {
  expect_identical(are_dbl_ish(factor(c(1, 2.2, NA))), rep(TRUE, 3))
  expect_identical(are_dbl_ish(factor(c("a"))), c(FALSE))
})

test_that("are_dbl_ish() respects coerce_factor (#23)", {
  expect_identical(
    are_dbl_ish(factor(1:2), coerce_factor = TRUE),
    c(TRUE, TRUE)
  )
  expect_identical(
    are_dbl_ish(factor(1:2), coerce_factor = FALSE),
    c(FALSE, FALSE)
  )
})

test_that("are_dbl_ish() works for complex (#23)", {
  expect_identical(are_dbl_ish(c(1 + 0i, 2.0 + 0i, NA)), rep(TRUE, 3))
  expect_identical(are_dbl_ish(c(1 + 1i)), c(FALSE))
})

test_that("are_dbl_ish() works for lists (#23)", {
  expect_identical(
    are_dbl_ish(list(1, 2L, "3.3", NA, 4.0)),
    rep(TRUE, 5)
  )
  expect_identical(
    are_dbl_ish(list("a", NULL, list(1))),
    c(FALSE, FALSE, TRUE)
  )
  expect_identical(
    are_dbl_ish(list("a", NULL, list(1, 2))),
    c(FALSE, FALSE, FALSE)
  )
  expect_identical(
    are_dbl_ish(list("a", NULL, 1)),
    c(FALSE, FALSE, TRUE)
  )
})

test_that("are_dbl_ish() returns FALSE for non-vectors (#23)", {
  expect_false(are_dbl_ish(mean))
})

test_that("is_dbl_ish() works (#23)", {
  expect_true(is_dbl_ish(1.0))
  expect_true(is_dbl_ish(c(1, 2.0, NA)))
  expect_true(is_dbl_ish(NULL))
  expect_true(is_dbl_ish(list(1, 2L, "3.3")))

  expect_false(is_dbl_ish("a"))
  expect_false(is_dbl_ish(list(1, "a")))
})
