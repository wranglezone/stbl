test_that("specify_fct can build a level checker (#150, #325)", {
  checker <- specify_fct(levels = c("a", "c"), to_na = "b")
  expect_identical(
    checker(c("a", "b", "c")),
    factor(c("a", NA, "c"), levels = c("a", "c"))
  )
  expect_pkg_error_classes(
    checker("invalid"),
    "stbl",
    "fct_levels"
  )
})

test_that("specify_fct_scalar can build a level checker (#150, #325)", {
  checker <- specify_fct_scalar(levels = c("a", "c"), to_na = "b")
  expect_identical(
    checker("a"),
    factor("a", levels = c("a", "c"))
  )
  expect_pkg_error_classes(
    checker(c("a", "c")),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_fct_scalar defaults to allow_null = FALSE (#197, #325)", {
  checker <- specify_fct_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_fct_scalar defaults to allow_zero_length = FALSE (#197, #325)", {
  checker <- specify_fct_scalar()
  expect_pkg_error_classes(checker(character(0)), "stbl", "bad_empty")
  expect_identical(
    checker(character(0), allow_zero_length = TRUE),
    factor(character(0))
  )
})

test_that("specify_factor() exists (#164, #325)", {
  expect_no_error(specify_factor())
})

test_that("stabilize_factor_scalar() exists (#164, #325)", {
  expect_no_error(specify_factor_scalar())
})
