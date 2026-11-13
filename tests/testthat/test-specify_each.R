test_that("specify_each() creates a working specifier (#287)", {
  spec <- specify_each(stabilize_int)
  expect_identical(spec(list("1", "2")), c(1L, 2L))
  expect_s3_class(spec, "stbl_specified_fn")
})

test_that("specify_each() passes through simplify (#402)", {
  spec <- specify_each(stabilize_int, simplify = FALSE)
  expect_identical(spec(list("1", "2")), list(1L, 2L))
  expect_identical(
    specify_each(stabilize_int, simplify = TRUE)(list("1", "2")),
    c(1L, 2L)
  )
})

test_that("specify_each() errors for duplicated simplify (#402)", {
  expect_pkg_error_classes(
    specify_each(stabilize_int, simplify = FALSE)(list("1"), simplify = TRUE),
    "stbl",
    "duplicate_args"
  )
})

test_that("specify_each() specifiers report x_arg in errors (#402)", {
  my_x <- list("a")
  expect_pkg_error_snapshot(
    specify_each(stabilize_int)(my_x),
    "stbl",
    "cant_stabilize_each"
  )
})

test_that("specify_each() errors for unnamed or unknown arguments (#402)", {
  expect_dot_errors(specify_each, stabilize_int)
})
