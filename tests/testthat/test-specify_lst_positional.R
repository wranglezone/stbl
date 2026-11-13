test_that("specify_lst_positional() creates a working specifier (#284)", {
  spec <- specify_lst_positional(stabilize_dbl_scalar, stabilize_chr_scalar)
  expect_identical(spec(list(1, "a")), list(1, "a"))
  expect_s3_class(spec, "stbl_specified_fn")
  expect_pkg_error_classes(
    spec(list("x", "a")),
    "stbl",
    "cant_stabilize_positional"
  )
})

test_that("specify_lst_positional() synonyms are identical (#284)", {
  expect_identical(specify_list_positional, specify_lst_positional)
  expect_identical(specify_tuple, specify_lst_positional)
})

test_that("specify_lst_positional() passes options through (#284)", {
  spec <- specify_tuple(
    stabilize_int_scalar,
    stabilize_int_scalar,
    .n_required = 1,
    .additional = TRUE,
    .simplify = TRUE
  )
  expect_identical(spec(list("1")), 1L)
  expect_identical(spec(list(1, 2, "x")), list(1L, 2L, "x"))
})

test_that("specify_lst_positional() appends specs from ... (#284)", {
  spec <- specify_tuple(stabilize_int_scalar)
  expect_identical(spec(list(1, "a"), stabilize_chr_scalar), list(1L, "a"))
})
