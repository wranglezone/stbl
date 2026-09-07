test_that("specify_one_of() creates a working specifier (#288)", {
  spec <- specify_one_of(specify_int(), specify_chr())
  expect_identical(spec("a"), "a")
  expect_s3_class(spec, "stbl_specified_fn")
})

test_that("specify_one_of() coerces via the single matching spec (#288)", {
  spec <- specify_one_of(specify_int(), specify_chr())
  expect_identical(spec(1.5), "1.5")
})

test_that("specify_one_of() passes through additional specs from ... (#288)", {
  spec <- specify_one_of(specify_int())
  expect_identical(spec("a", specify_chr()), "a")
})

test_that("specify_one_of() errors when zero specs match (#288)", {
  spec <- specify_one_of(specify_lgl(), specify_int())
  expect_pkg_error_classes(spec("maybe"), "stbl", "cant_stabilize_one_of")
})

test_that("specify_one_of() errors when more than one spec matches (#288)", {
  spec <- specify_one_of(specify_int(), specify_dbl())
  expect_pkg_error_classes(spec("1"), "stbl", "cant_stabilize_one_of")
})
