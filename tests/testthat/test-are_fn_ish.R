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

test_that("is_fn_ish() returns FALSE with bad ':' usage (#250)", {
  expect_false(is_fn_ish("base:mean"))
  expect_false(is_fn_ish("base::mean::thing"))
  expect_false(is_fn_ish("base::mean:thing"))
  expect_false(is_fn_ish("base:mean:thing"))
  expect_false(is_fn_ish("base:mean::thing"))
})

test_that("is_function_ish() exists (#250)", {
  expect_identical(is_function_ish(mean), is_fn_ish(mean))
})

# are_fn_ish() ------------------------------------------------------------------

test_that("are_fn_ish() returns TRUE for functions (#250)", {
  expect_true(are_fn_ish(mean))
  expect_true(are_fn_ish(\(x) x + 1))
})

test_that("are_fn_ish() returns TRUE for formulas (#250)", {
  expect_true(are_fn_ish(~ . + 1))
  expect_true(are_fn_ish(y ~ x))
})

test_that("are_fn_ish() does element-wise check for character (#250)", {
  expect_equal(
    are_fn_ish(c("mean", "stats::median", NA, "", "1bad")),
    c(TRUE, TRUE, FALSE, FALSE, FALSE)
  )
})

test_that("are_fn_ish() returns logical(0) for NULL (#250)", {
  expect_equal(are_fn_ish(NULL), logical(0))
})

test_that("are_fn_ish() returns FALSE for non-fn-ish types (#250)", {
  expect_false(are_fn_ish(1L))
  expect_false(are_fn_ish(TRUE))
  expect_false(are_fn_ish(1.5))
})

test_that("are_function_ish() is a synonym of are_fn_ish() (#250)", {
  expect_identical(are_function_ish, are_fn_ish)
})
