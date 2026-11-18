test_that("specify_all_of() creates a working specifier (#288)", {
  spec <- specify_all_of(stabilize_int, stabilize_int_scalar)
  expect_identical(spec(1L), 1L)
  expect_s3_class(spec, "stbl_specified_fn")
})

test_that("specify_all_of() passes through additional specs from ... (#288)", {
  spec <- specify_all_of(stabilize_int)
  expect_identical(spec(1L, stabilize_int_scalar), 1L)
})
