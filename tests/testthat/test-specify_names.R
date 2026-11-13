# specify_names ----

test_that("specify_names() creates a working specifier (#26)", {
  spec <- specify_names(required = "a")
  given <- c(a = 1, b = 2)
  expect_identical(spec(given), given)
  expect_s3_class(spec, "stbl_specified_fn")
})

test_that("specify_names() passes through all arguments (#26)", {
  expect_pkg_error_classes(
    specify_names(required = "z")(c(a = 1)),
    "stbl",
    "missing_element"
  )
  expect_pkg_error_classes(
    specify_names(allowed_names = "a")(c(b = 1)),
    "stbl",
    "allowed_names"
  )
  expect_identical(specify_names(spec = toupper)(c(a = 1)), c(A = 1))
  expect_identical(
    specify_names(allow_duplicate_names = TRUE)(c(a = 1, a = 2)),
    c(a = 1, a = 2)
  )
  expect_pkg_error_classes(
    specify_names()(c(a = 1, a = 2)),
    "stbl",
    "duplicate_names"
  )
})

test_that("specify_names() specifiers report x_arg in errors (#26)", {
  my_x <- c(a = 1, a = 2)
  expect_pkg_error_snapshot(specify_names()(my_x), "stbl", "duplicate_names")
})

test_that("specify_names() errors for unnamed or unknown arguments (#402)", {
  expect_dot_errors(specify_names)
})

test_that("specify_names() specifiers accept extra stabilize_names() args (#402)", {
  expect_pkg_error_classes(
    specify_names(required = "z")(c(a = 1), required = "a"),
    "stbl",
    "duplicate_args"
  )
  expect_identical(
    specify_names(required = "a")(c(a = 1), allowed_names = "a"),
    c(a = 1)
  )
})
