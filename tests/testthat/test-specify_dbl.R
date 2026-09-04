test_that("specify_dbl can build a value checker (#148, #325)", {
  checker <- specify_dbl(min_value = 27.2)
  expect_identical(
    checker(30:40 + 0.1),
    30:40 + 0.1
  )
  expect_pkg_error_classes(
    checker(19.2),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dbl can enforce unique elements (#280, #325)", {
  checker <- specify_dbl(unique = TRUE)
  expect_identical(checker(c(1.1, 2.2)), c(1.1, 2.2))
  expect_pkg_error_classes(
    checker(c(1.1, 2.2, 1.1)),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_dbl_scalar can build a value checker (#148, #325)", {
  checker <- specify_dbl_scalar(min_value = 27.2)
  expect_identical(
    checker(30.1),
    30.1
  )
  expect_pkg_error_classes(
    checker(30:40 + 0.1),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_dbl_scalar defaults to allow_null = FALSE (#197, #325)", {
  checker <- specify_dbl_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_dbl_scalar defaults to allow_zero_length = FALSE (#197, #325)", {
  checker <- specify_dbl_scalar()
  expect_pkg_error_classes(checker(double(0)), "stbl", "bad_empty")
  expect_identical(checker(double(0), allow_zero_length = TRUE), double(0))
})

test_that("specify_double() exists (#164, #325)", {
  expect_no_error(specify_double())
})

test_that("stabilize_double_scalar() exists (#164, #325)", {
  expect_no_error(specify_double_scalar())
})

test_that("specify_dbl can enforce allowed_values (#282, #325)", {
  checker <- specify_dbl(allowed_values = c(1.1, 2.2))
  expect_identical(checker(1.1), 1.1)
  expect_pkg_error_classes(checker(3.3), "stbl", "allowed_values")
})

test_that("specify_dbl can enforce multiple_of (#283)", {
  checker <- specify_dbl(multiple_of = 0.1)
  expect_identical(checker(0.2), 0.2)
  expect_pkg_error_classes(checker(0.25), "stbl", "not_multiple")
})
