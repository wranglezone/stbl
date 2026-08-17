test_that("specify_lgl can build a checker (#151, #325)", {
  checker <- specify_lgl(allow_na = FALSE)
  expect_identical(
    checker(c(TRUE, "False")),
    c(TRUE, FALSE)
  )
  expect_pkg_error_classes(
    checker(NA),
    "stbl",
    "bad_na"
  )
})

test_that("specify_lgl_scalar can build a value checker (#151, #325)", {
  checker <- specify_lgl_scalar(allow_na = FALSE)
  expect_identical(
    checker("True"),
    TRUE
  )
  expect_pkg_error_classes(
    checker(c(TRUE, FALSE)),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_lgl_scalar defaults to allow_null = FALSE (#197, #325)", {
  checker <- specify_lgl_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_lgl_scalar defaults to allow_zero_length = FALSE (#197, #325)", {
  checker <- specify_lgl_scalar()
  expect_pkg_error_classes(checker(logical(0)), "stbl", "bad_empty")
  expect_identical(checker(logical(0), allow_zero_length = TRUE), logical(0))
})

test_that("specify_logical() exists (#164, #325)", {
  expect_no_error(specify_logical())
})

test_that("stabilize_logical_scalar() exists (#164, #325)", {
  expect_no_error(specify_logical_scalar())
})

test_that("specify_lgl can enforce allowed_values (#282, #325)", {
  checker <- specify_lgl(allowed_values = TRUE)
  expect_identical(checker(TRUE), TRUE)
  expect_pkg_error_classes(checker(FALSE), "stbl", "allowed_values")
})
