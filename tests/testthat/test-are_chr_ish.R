test_that("are_chr_ish() returns TRUE for every element of a chr (#93)", {
  expect_identical(are_chr_ish(letters), rep(TRUE, 26))
  given <- c(letters, NA)
  expect_identical(are_chr_ish(given), rep(TRUE, 27))
})

test_that("are_chr_ish() works for NULL (#93)", {
  expect_identical(are_chr_ish(NULL), logical(0))
})

test_that("are_chr_ish() returns TRUE for every element of other atomics (#93)", {
  expect_identical(are_chr_ish(1:10), rep(TRUE, 10))
  expect_identical(are_chr_ish(c(TRUE, FALSE)), c(TRUE, TRUE))
  expect_identical(are_chr_ish(factor(letters)), rep(TRUE, 26))
  expect_identical(are_chr_ish(as.raw(1:10)), rep(TRUE, 10))
  expect_identical(are_chr_ish(as.complex(1:10)), rep(TRUE, 10))
})

test_that("are_chr_ish() works for lists and data.frames (#93, #128)", {
  expect_identical(are_chr_ish(list("a", 1, TRUE)), c(TRUE, TRUE, TRUE))
  expect_identical(are_chr_ish(list("a", NULL, "b")), c(TRUE, FALSE, TRUE))
  expect_identical(are_chr_ish(list(a = 1, b = 1:5)), c(TRUE, FALSE))
  expect_identical(are_chr_ish(list(a = character(0))), c(FALSE))
  expect_identical(are_chr_ish(mtcars), rep(FALSE, length(mtcars)))
  expect_identical(are_chr_ish(list(list(1), 2)), c(TRUE, TRUE))
})

test_that("are_chr_ish() returns unnamed vectors (#93)", {
  expect_named(are_chr_ish(list(a = 1, b = "c")), NULL)
})

test_that("are_chr_ish() returns FALSE for non-vectors (#93)", {
  expect_false(are_chr_ish(mean))
})

test_that("is_chr_ish() returns a single TRUE for coercible objects (#93)", {
  expect_true(is_chr_ish("a"))
  expect_true(is_chr_ish(1:10))
  expect_true(is_chr_ish(NULL))
  expect_true(is_chr_ish(list("a", 1, TRUE)))
})

test_that("is_chr_ish() works for NULL (#93)", {
  expect_true(is_chr_ish(NULL))
})

test_that("is_chr_ish() returns FALSE for uncoercibles (#93)", {
  expect_false(is_chr_ish(mean))
  expect_false(is_chr_ish(list("a", NULL, "b")))
  expect_false(is_chr_ish(list(a = 1, b = 1:5)))
  expect_false(is_chr_ish(list(a = character(0))))
  expect_false(is_chr_ish(mtcars))
})
