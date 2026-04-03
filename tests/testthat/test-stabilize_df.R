test_that("stabilize_df() returns NULL for NULL input by default (#142)", {
  expect_null(stabilize_df(NULL))
})

test_that("stabilize_df() respects .allow_null (#142)", {
  skip_on_covr()
  expect_pkg_error_snapshot(
    stabilize_df(NULL, .allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_df(NULL, .allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_df() errors for non-coercible input (#142)", {
  skip_on_covr()
  expect_pkg_error_snapshot(
    stabilize_df("not a data frame"),
    "stbl",
    "coerce",
    "data.frame"
  )
  # When called through a wrapper, the argument appears as a symbol; the string
  # is coerced to a one-column data frame and stabilize_df then rejects the
  # unexpected column.
  expect_pkg_error_snapshot(
    wrapped_stabilize_df("not a data frame"),
    "stbl",
    "bad_named"
  )
})

test_that("stabilize_df() coerces a named list to a data frame (#142)", {
  given_list <- list(name = "Alice", age = 30L)
  result <- stabilize_df(
    given_list,
    name = specify_chr_scalar(),
    age = specify_int_scalar()
  )
  expect_s3_class(result, "data.frame")
  expect_identical(result$name, "Alice")
  expect_identical(result$age, 30L)
})

test_that("stabilize_df() returns a valid data frame unchanged (#142)", {
  given <- data.frame(name = "Alice", age = 30L)
  result <- stabilize_df(
    given,
    name = specify_chr_scalar(),
    age = specify_int_scalar()
  )
  expect_identical(result, given)
  expect_s3_class(result, "data.frame")
})

test_that("stabilize_df() coerces compatible column types (#142)", {
  given <- data.frame(age = "30")
  result <- stabilize_df(given, age = specify_int_scalar())
  expect_identical(result$age, 30L)
  expect_s3_class(result, "data.frame")
})

test_that("stabilize_df() errors when required column is missing (#142)", {
  skip_on_covr()
  expect_pkg_error_snapshot(
    stabilize_df(data.frame(foo = "a"), name = specify_chr_scalar()),
    "stbl",
    "missing_element"
  )
})

test_that("stabilize_df() errors informatively when column fails validation (#142)", {
  skip_on_covr()
  expect_pkg_error_snapshot(
    stabilize_df(
      data.frame(count = "not-an-int"),
      count = specify_int_scalar()
    ),
    "stbl",
    "incompatible_type"
  )
})

test_that("stabilize_df() errors on extra columns by default (#142)", {
  skip_on_covr()
  expect_pkg_error_snapshot(
    stabilize_df(data.frame(a = 1L, b = 2L), a = specify_int_scalar()),
    "stbl",
    "bad_named"
  )
})

test_that("stabilize_df() allows extra columns with .extra_cols (#142)", {
  given <- data.frame(a = 1L, b = 2L)
  result <- stabilize_df(
    given,
    a = specify_int_scalar(),
    .extra_cols = stabilize_present
  )
  expect_identical(result, given)
})

test_that("stabilize_df() validates extra columns with .extra_cols (#142)", {
  skip_on_covr()
  expect_pkg_error_snapshot(
    stabilize_df(
      data.frame(a = 1L, b = "not-int"),
      a = specify_int_scalar(),
      .extra_cols = specify_int_scalar()
    ),
    "stbl",
    "incompatible_type"
  )
})

test_that("stabilize_df() enforces .min_rows (#142)", {
  expect_error(
    stabilize_df(
      mtcars[0, ],
      .min_rows = 1,
      .extra_cols = stabilize_present
    ),
    class = "stbl-error-too_few_rows"
  )
})

test_that("stabilize_df() enforces .min_rows (snapshot) (#142)", {
  skip_on_covr()
  expect_pkg_error_snapshot(
    stabilize_df(
      mtcars[0, ],
      .min_rows = 1,
      .extra_cols = stabilize_present
    ),
    "stbl",
    "too_few_rows"
  )
})

test_that("stabilize_df() enforces .max_rows (#142)", {
  expect_error(
    stabilize_df(
      mtcars,
      .max_rows = 5,
      .extra_cols = stabilize_present
    ),
    class = "stbl-error-too_many_rows"
  )
})

test_that("stabilize_df() enforces .max_rows (snapshot) (#142)", {
  skip_on_covr()
  expect_pkg_error_snapshot(
    stabilize_df(
      mtcars,
      .max_rows = 5,
      .extra_cols = stabilize_present
    ),
    "stbl",
    "too_many_rows"
  )
})

test_that("stabilize_df() passes with valid row counts (#142)", {
  expect_no_error(
    stabilize_df(
      mtcars,
      .min_rows = 32,
      .max_rows = 32,
      .extra_cols = stabilize_present
    )
  )
})

test_that("stabilize_df() enforces .col_names (#142)", {
  expect_no_error(
    stabilize_df(
      data.frame(a = 1L, b = 2L),
      .col_names = c("a", "b"),
      .extra_cols = stabilize_present
    )
  )
  expect_error(
    stabilize_df(
      data.frame(a = 1L),
      .col_names = c("a", "b"),
      .extra_cols = stabilize_present
    ),
    class = "stbl-error-missing_cols"
  )
})

test_that("stabilize_df() enforces .col_names (snapshot) (#142)", {
  skip_on_covr()
  expect_pkg_error_snapshot(
    stabilize_df(
      data.frame(a = 1L),
      .col_names = c("a", "b"),
      .extra_cols = stabilize_present
    ),
    "stbl",
    "missing_cols"
  )
})

test_that("stabilize_df() allows .col_names alongside ... specs (#142)", {
  given <- data.frame(a = 1L, b = "hello", c = TRUE)
  result <- stabilize_df(
    given,
    a = specify_int_scalar(),
    .col_names = c("b", "c"),
    .extra_cols = stabilize_present
  )
  expect_identical(result, given)
})

test_that("stabilize_df() preserves data frame class after column coercion (#142)", {
  df <- data.frame(x = c("1", "2", "3"), y = 1:3)
  result <- stabilize_df(
    df,
    x = specify_int(),
    y = specify_int()
  )
  expect_s3_class(result, "data.frame")
  expect_identical(result$x, 1L:3L)
  expect_identical(result$y, 1L:3L)
})

test_that("stabilize_df() works with no column specs and .extra_cols (#142)", {
  given <- data.frame(a = 1L, b = "hello")
  result <- stabilize_df(given, .extra_cols = stabilize_present)
  expect_identical(result, given)
})

test_that("stabilize_df() with unnamed specs errors informatively (#142)", {
  skip_on_covr()
  expect_pkg_error_snapshot(
    stabilize_df(data.frame(a = 1L), specify_int_scalar()),
    "stbl",
    "unnamed_spec"
  )
})

test_that("stabilise_df() exists (#142)", {
  expect_no_error(stabilise_df(NULL))
})

test_that("stabilize_data_frame() exists (#142)", {
  expect_no_error(stabilize_data_frame(NULL))
})

test_that("stabilise_data_frame() exists (#142)", {
  expect_no_error(stabilise_data_frame(NULL))
})
