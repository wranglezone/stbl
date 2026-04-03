test_that("object_type returns expected types (#95)", {
  expect_identical(
    object_type(factor(letters)),
    "factor"
  )
  expect_identical(
    object_type(),
    "missing"
  )
  expect_identical(
    object_type(quote(mean(1:10))),
    "call"
  )
  expect_identical(
    object_type(rlang::quo(whatever)),
    "quosure"
  )
})
