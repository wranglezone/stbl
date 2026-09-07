test_that("specify_each() creates a working specifier (#287)", {
  spec <- specify_each(stabilize_int)
  expect_identical(spec(list("1", "2")), c(1L, 2L))
  expect_s3_class(spec, "stbl_specified_fn")
})

test_that("specify_each() passes through simplify (#287)", {
  spec <- specify_each(stabilize_int)
  expect_identical(spec(list("1", "2"), simplify = FALSE), list(1L, 2L))
})
