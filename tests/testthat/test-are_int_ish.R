test_that("are_int_ish() works for ints (#93)", {
  expect_identical(are_int_ish(1:10), rep(TRUE, 10))
})

test_that("are_int_ish() works for NULL (#93)", {
  expect_identical(are_int_ish(NULL), logical(0))
})

test_that("are_int_ish() works for logicals (#93)", {
  expect_identical(are_int_ish(c(TRUE, FALSE, NA)), rep(TRUE, 3))
})

test_that("are_int_ish() works for doubles (#93)", {
  expect_identical(are_int_ish(c(1, 2.0, NA)), c(TRUE, TRUE, TRUE))
  expect_identical(are_int_ish(c(1.1, Inf, -Inf)), c(FALSE, FALSE, FALSE))
})

test_that("are_int_ish() works for characters (#93)", {
  expect_identical(
    are_int_ish(c("1", "2.0", NA)),
    c(TRUE, TRUE, TRUE)
  )
  expect_identical(
    are_int_ish(c("1.1", "a", "")),
    c(FALSE, FALSE, FALSE)
  )
})

test_that("are_int_ish() respects coerce_character (#93)", {
  expect_identical(
    are_int_ish(c("1", "2.0"), coerce_character = TRUE),
    c(TRUE, TRUE)
  )
  expect_identical(
    are_int_ish(c("1", "2.0"), coerce_character = FALSE),
    c(FALSE, FALSE)
  )
})

test_that("are_int_ish() works for factors (#93)", {
  expect_identical(are_int_ish(factor(c(1, 2, NA))), rep(TRUE, 3))
  expect_identical(are_int_ish(factor(c("1.1", "a"))), c(FALSE, FALSE))
})

test_that("are_int_ish() respects coerce_factor (#93)", {
  expect_identical(
    are_int_ish(factor(1:2), coerce_factor = TRUE),
    c(TRUE, TRUE)
  )
  expect_identical(
    are_int_ish(factor(1:2), coerce_factor = FALSE),
    c(FALSE, FALSE)
  )
})

test_that("are_int_ish() works for complex (#93)", {
  expect_identical(are_int_ish(c(1 + 0i, 2.0 + 0i, NA)), rep(TRUE, 3))
  expect_identical(are_int_ish(c(1 + 1i, 1.1 + 0i)), c(FALSE, FALSE))
})

test_that("are_int_ish() works for lists (#93, #128)", {
  expect_identical(
    are_int_ish(list(1, 2L, "3", NA, 4.0)),
    rep(TRUE, 5)
  )
  expect_identical(
    are_int_ish(list(1.1, "a", NULL, list(1))),
    c(FALSE, FALSE, FALSE, TRUE)
  )
  expect_identical(are_int_ish(list(list(1), 2)), c(TRUE, TRUE))
  expect_identical(are_int_ish(list(1, 1:5)), c(TRUE, FALSE))
})

test_that("are_int_ish() returns FALSE for non-vectors (#93)", {
  expect_false(are_int_ish(mean))
})

test_that("are_int_ish() returns FALSE for unhandled S3 objects (#93)", {
  expect_false(is_int_ish(Sys.Date()))
  expect_identical(
    are_int_ish(as.Date(c("2025-01-01", "2025-01-02"))),
    c(FALSE, FALSE)
  )
  expect_identical(
    are_int_ish(list(1L, Sys.Date())),
    c(TRUE, FALSE)
  )
})

test_that("is_int_ish() works (#93)", {
  expect_true(is_int_ish(1L))
  expect_true(is_int_ish(c(1, 2.0, NA)))
  expect_true(is_int_ish(NULL))
  expect_true(is_int_ish(list(1, 2L, "3")))

  expect_false(is_int_ish(1.1))
  expect_false(is_int_ish("a"))
  expect_false(is_int_ish(list(1, "a")))
})

test_that("are_integer_ish() exists (#164)", {
  expect_no_error(are_integer_ish())
})

test_that("is_integer_ish() exists (#164)", {
  expect_no_error(is_integer_ish(1))
})
