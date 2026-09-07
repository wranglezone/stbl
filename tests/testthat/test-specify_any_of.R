test_that("specify_any_of() creates a working specifier (#288)", {
  spec <- specify_any_of(specify_int(), specify_chr())
  expect_identical(spec(1L), 1L)
  expect_s3_class(spec, "stbl_specified_fn")
})

test_that("specify_any_of() passes through additional specs from ... (#288)", {
  spec <- specify_any_of(specify_int())
  expect_identical(spec("a", specify_chr()), "a")
})

test_that("specify_any_of() works nested inside stabilize_lst() (#288)", {
  int_or_chr <- specify_any_of(specify_int(), specify_chr())
  given <- list(a = 1L)
  expect_identical(stabilize_lst(given, a = int_or_chr), given)
})
