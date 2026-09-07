test_that("specify_all_of() creates a working specifier (#288)", {
  spec <- specify_all_of(specify_int(), specify_int_scalar())
  expect_identical(spec(1L), 1L)
  expect_s3_class(spec, "stbl_specified_fn")
})

test_that("specify_all_of() applies each spec to the original x independently (#288)", {
  spec <- specify_all_of(specify_chr(regex = "^a"), specify_chr(regex = "b$"))
  expect_identical(spec("ab"), "ab")
})

test_that("specify_all_of() passes through additional specs from ... (#288)", {
  spec <- specify_all_of(specify_int())
  expect_identical(spec(1L, specify_int_scalar()), 1L)
})

test_that("specify_all_of() errors when a spec fails (#288)", {
  spec <- specify_all_of(specify_int(), specify_chr())
  expect_pkg_error_classes(spec("a"), "stbl", "cant_stabilize_all_of")
})

test_that("specify_all_of() errors when specs disagree on the coerced value (#288)", {
  spec <- specify_all_of(specify_int(), specify_dbl())
  expect_pkg_error_classes(spec(1L), "stbl", "inconsistent_all_of")
})
