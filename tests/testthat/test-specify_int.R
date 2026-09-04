test_that("specify_int can build a value checker (#149, #325)", {
  checker <- specify_int(min_value = 2)
  expect_identical(
    checker(2:10),
    2:10
  )
  expect_pkg_error_classes(
    checker(1),
    "stbl",
    "outside_range"
  )
})

test_that("specify_int can enforce unique elements (#280, #325)", {
  checker <- specify_int(unique = TRUE)
  expect_identical(checker(c(1L, 2L)), c(1L, 2L))
  expect_pkg_error_classes(checker(c(1L, 2L, 1L)), "stbl", "duplicate_elements")
})

test_that("specify_int_scalar can build a value checker (#149, #325)", {
  checker <- specify_int_scalar(min_value = 2)
  expect_identical(
    checker(2),
    2L
  )
  expect_pkg_error_classes(
    checker(2:10),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_int_scalar defaults to allow_null = FALSE (#197, #325)", {
  checker <- specify_int_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_int_scalar defaults to allow_zero_length = FALSE (#197, #325)", {
  checker <- specify_int_scalar()
  expect_pkg_error_classes(checker(integer(0)), "stbl", "bad_empty")
  expect_identical(checker(integer(0), allow_zero_length = TRUE), integer(0))
})

test_that("specify_integer() exists (#164, #325)", {
  expect_no_error(specify_integer())
})

test_that("stabilize_integer_scalar() exists (#164, #325)", {
  expect_no_error(specify_integer_scalar())
})

test_that("specify_int can enforce allowed_values (#282, #325)", {
  checker <- specify_int(allowed_values = c(1L, 2L))
  expect_identical(checker(1L), 1L)
  expect_pkg_error_classes(checker(5L), "stbl", "allowed_values")
})

test_that("specify_int can enforce exclusive_min_value and exclusive_max_value (#276, #325)", {
  checker <- specify_int(exclusive_min_value = 1, exclusive_max_value = 10)
  expect_identical(checker(5L), 5L)
  expect_pkg_error_classes(checker(1L), "stbl", "outside_range")
  expect_pkg_error_classes(checker(10L), "stbl", "outside_range")
})

test_that("specify_int can enforce multiple_of (#283)", {
  checker <- specify_int(multiple_of = 2)
  expect_identical(checker(4L), 4L)
  expect_pkg_error_classes(checker(5L), "stbl", "not_multiple")
})
