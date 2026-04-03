test_that("specify_df() creates a working validator (#142)", {
  validator <- specify_df(
    name = specify_chr_scalar(),
    age = specify_int_scalar()
  )
  given <- data.frame(name = "Alice", age = 30L)
  expect_identical(validator(given), given)
})

test_that("specify_df() errors when required column is missing (#142)", {
  skip_on_covr()
  validator <- specify_df(
    name = specify_chr_scalar(),
    age = specify_int_scalar()
  )
  expect_pkg_error_snapshot(
    validator(data.frame(name = "Alice")),
    "stbl",
    "missing_element"
  )
})

test_that("specify_df() passes through .min_rows, .max_rows (#142)", {
  skip_on_covr()
  validator <- specify_df(.min_rows = 2, .extra_cols = stabilize_present)
  expect_pkg_error_snapshot(
    validator(data.frame(a = 1L)),
    "stbl",
    "too_few_rows"
  )
})

test_that("specify_df() passes through .col_names (#142)", {
  skip_on_covr()
  validator <- specify_df(
    .col_names = c("a", "b"),
    .extra_cols = stabilize_present
  )
  expect_pkg_error_snapshot(
    validator(data.frame(a = 1L)),
    "stbl",
    "missing_cols"
  )
})

test_that("specify_df() allows additional specs via ... (#142)", {
  base_validator <- specify_df(.extra_cols = stabilize_present)
  given <- data.frame(a = 1L, b = "hello")
  result <- base_validator(given, a = specify_int_scalar())
  expect_identical(result, given)
})

test_that("specify_data_frame() exists (#142)", {
  expect_no_error(specify_data_frame())
})
