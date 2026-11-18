test_that("specify_df() creates a working validator (#142)", {
  validator <- specify_df(
    name = stabilize_chr,
    age = stabilize_int
  )
  given <- data.frame(name = "Alice", age = 30L)
  expect_identical(validator(given), given)
})

test_that("specify_df() errors when required column is missing (#142)", {
  validator <- specify_df(
    name = stabilize_chr,
    age = stabilize_int
  )
  expect_pkg_error_snapshot(
    validator(data.frame(name = "Alice")),
    "stbl",
    "missing_element"
  )
})

test_that("specify_df() passes through .required (#279)", {
  validator <- specify_df(
    name = stabilize_chr,
    age = stabilize_int,
    .required = "name"
  )
  given <- data.frame(name = "Alice")
  expect_identical(validator(given), given)
})

test_that("specify_df() passes through .min_rows, .max_rows (#142)", {
  validator <- specify_df(.min_rows = 2, .extra_cols = assert_present)
  expect_pkg_error_snapshot(
    validator(data.frame(a = 1L)),
    "stbl",
    "too_few_rows"
  )
})

test_that("specify_df() passes through .col_names (#142)", {
  withr::local_options(lifecycle_verbosity = "quiet")
  validator <- specify_df(
    .col_names = c("a", "b"),
    .extra_cols = assert_present
  )
  expect_pkg_error_snapshot(
    validator(data.frame(a = 1L)),
    "stbl",
    "missing_cols"
  )
})

test_that("specify_df() passes through .allow_zero_length (#344)", {
  validator <- specify_df(name = stabilize_chr)
  expect_identical(validator(data.frame()), data.frame())

  validator_strict <- specify_df(
    name = stabilize_chr,
    .allow_zero_length = FALSE
  )
  expect_pkg_error_classes(
    validator_strict(data.frame()),
    "stbl",
    "missing_element"
  )
})

test_that("specify_df() allows additional specs via ... (#142)", {
  base_validator <- specify_df(.extra_cols = assert_present)
  given <- data.frame(a = 1L, b = "hello")
  result <- base_validator(given, a = stabilize_int)
  expect_identical(result, given)
})

test_that("specify_data_frame() exists (#142)", {
  expect_no_error(specify_data_frame())
})

test_that("specify_df() accepts columns named 'x_arg', 'call', 'x_class' (#204)", {
  spec <- specify_df(
    x_arg = stabilize_chr,
    call = stabilize_chr
  )
  given <- data.frame(x_arg = "foo", call = "bar")
  expect_identical(spec(given), given)
})

test_that("specify_df() args match stabilize_df() args (#400)", {
  supplied <- c(".x", ".x_arg", ".call", ".x_class")
  expected <- formals(stabilize_df)
  expected <- expected[!names(expected) %in% supplied]
  expect_identical(as.list(formals(specify_df)), as.list(expected))
})

test_that("specify_df() applies and validates .patterns (#292)", {
  spec <- specify_df(.patterns = list("^a" = stabilize_int))
  expect_identical(spec(data.frame(a = 1)), data.frame(a = 1L))
  expect_pkg_error_classes(
    specify_df(.patterns = list("[" = stabilize_int)),
    "stbl",
    "bad_patterns",
    "invalid_regex"
  )
})
