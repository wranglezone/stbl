test_that("specify_one_of() creates a working specifier (#288)", {
  spec <- specify_one_of(specify_int(), specify_chr())
  expect_identical(spec("a"), "a")
  expect_s3_class(spec, "stbl_specified_fn")
})

test_that("specify_one_of() passes through additional specs from ... (#288)", {
  spec <- specify_one_of(specify_int())
  expect_identical(spec("a", specify_chr()), "a")
})
