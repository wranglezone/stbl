test_that("is_fn_ish() returns TRUE for functions (#250)", {
  expect_true(is_fn_ish(mean))
  expect_true(is_fn_ish(\(x) x + 1))
  expect_true(is_fn_ish(base::mean))
})

test_that("is_fn_ish() returns TRUE for formulas (#250)", {
  expect_true(is_fn_ish(~ . + 1))
  expect_true(is_fn_ish(y ~ x))
})

test_that("is_fn_ish() returns TRUE for length-1 character strings (#250)", {
  expect_true(is_fn_ish("mean"))
  expect_true(is_fn_ish("stats::median"))
})

test_that("is_fn_ish() returns FALSE for NULL (#250)", {
  expect_false(is_fn_ish(NULL))
})

test_that("is_fn_ish() returns FALSE for non-character vectors (#250)", {
  expect_false(is_fn_ish(1L))
  expect_false(is_fn_ish(TRUE))
  expect_false(is_fn_ish(1.5))
})

test_that("is_fn_ish() returns FALSE for length != 1 character (#250)", {
  expect_false(is_fn_ish(character()))
  expect_false(is_fn_ish(c("mean", "sum")))
  expect_false(is_fn_ish(NA_character_))
})

test_that("is_function_ish() exists (#250)", {
  expect_identical(is_function_ish(mean), is_fn_ish(mean))
})
