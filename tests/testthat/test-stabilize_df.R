test_that("stabilize_df() returns NULL for NULL input by default (#199)", {
  expect_null(stabilize_df(NULL))
})

test_that("stabilize_df() respects .allow_null (#199)", {
  expect_error(
    stabilize_df(NULL, .allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    stabilize_df(NULL, .allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_df(NULL, .allow_null = FALSE),
    error = TRUE
  )
})

test_that("stabilize_df() errors for non-data-frame input (#199)", {
  expect_error(
    stabilize_df(list(a = 1L)),
    class = .compile_dash("stbl", "error", "coerce", "data.frame")
  )
  expect_snapshot(
    stabilize_df(list(a = 1L)),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_df(list(a = 1L)),
    error = TRUE
  )
  expect_error(
    stabilize_df("not a data frame"),
    class = .compile_dash("stbl", "error", "coerce", "data.frame")
  )
})

test_that("stabilize_df() returns a valid data frame unchanged (#199)", {
  given <- data.frame(name = "Alice", age = 30L)
  result <- stabilize_df(
    given,
    name = specify_chr_scalar(),
    age = specify_int_scalar()
  )
  expect_identical(result, given)
  expect_s3_class(result, "data.frame")
})

test_that("stabilize_df() coerces compatible column types (#199)", {
  given <- data.frame(age = "30")
  result <- stabilize_df(given, age = specify_int_scalar())
  expect_identical(result$age, 30L)
  expect_s3_class(result, "data.frame")
})

test_that("stabilize_df() errors when required column is missing (#199)", {
  expect_error(
    stabilize_df(data.frame(foo = "a"), name = specify_chr_scalar()),
    class = .compile_dash("stbl", "error", "missing_element")
  )
  expect_snapshot(
    stabilize_df(data.frame(foo = "a"), name = specify_chr_scalar()),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_df(data.frame(foo = "a"), name = specify_chr_scalar()),
    error = TRUE
  )
})

test_that("stabilize_df() errors informatively when column fails validation (#199)", {
  expect_error(
    stabilize_df(data.frame(count = "not-an-int"), count = specify_int_scalar()),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    stabilize_df(data.frame(count = "not-an-int"), count = specify_int_scalar()),
    error = TRUE
  )
})

test_that("stabilize_df() errors on extra columns by default (#199)", {
  expect_error(
    stabilize_df(data.frame(a = 1L, b = 2L), a = specify_int_scalar()),
    class = .compile_dash("stbl", "error", "bad_named")
  )
  expect_snapshot(
    stabilize_df(data.frame(a = 1L, b = 2L), a = specify_int_scalar()),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_df(data.frame(a = 1L, b = 2L), a = specify_int_scalar()),
    error = TRUE
  )
})

test_that("stabilize_df() allows extra columns with .extra_cols (#199)", {
  given <- data.frame(a = 1L, b = 2L)
  result <- stabilize_df(given, a = specify_int_scalar(), .extra_cols = stabilize_present)
  expect_identical(result, given)
})

test_that("stabilize_df() validates extra columns with .extra_cols (#199)", {
  expect_error(
    stabilize_df(
      data.frame(a = 1L, b = "not-int"),
      a = specify_int_scalar(),
      .extra_cols = specify_int_scalar()
    ),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
})

test_that("stabilize_df() enforces .min_rows (#199)", {
  expect_error(
    stabilize_df(
      mtcars[0, ],
      .min_rows = 1,
      .extra_cols = stabilize_present
    ),
    class = .compile_dash("stbl", "error", "too_few_rows")
  )
  expect_snapshot(
    stabilize_df(mtcars[0, ], .min_rows = 1, .extra_cols = stabilize_present),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_df(mtcars[0, ], .min_rows = 1, .extra_cols = stabilize_present),
    error = TRUE
  )
})

test_that("stabilize_df() enforces .max_rows (#199)", {
  expect_error(
    stabilize_df(
      mtcars,
      .max_rows = 5,
      .extra_cols = stabilize_present
    ),
    class = .compile_dash("stbl", "error", "too_many_rows")
  )
  expect_snapshot(
    stabilize_df(mtcars, .max_rows = 5, .extra_cols = stabilize_present),
    error = TRUE
  )
})

test_that("stabilize_df() passes with valid row counts (#199)", {
  expect_no_error(
    stabilize_df(mtcars, .min_rows = 32, .max_rows = 32, .extra_cols = stabilize_present)
  )
})

test_that("stabilize_df() enforces .col_names (#199)", {
  expect_error(
    stabilize_df(data.frame(a = 1L), .col_names = c("a", "b"), .extra_cols = stabilize_present),
    class = .compile_dash("stbl", "error", "missing_cols")
  )
  expect_snapshot(
    stabilize_df(data.frame(a = 1L), .col_names = c("a", "b"), .extra_cols = stabilize_present),
    error = TRUE
  )
})

test_that("stabilize_df() passes when all .col_names are present (#199)", {
  expect_no_error(
    stabilize_df(
      data.frame(a = 1L, b = 2L),
      .col_names = c("a", "b"),
      .extra_cols = stabilize_present
    )
  )
})

test_that("stabilize_df() allows .col_names alongside ... specs (#199)", {
  given <- data.frame(a = 1L, b = "hello", c = TRUE)
  result <- stabilize_df(
    given,
    a = specify_int_scalar(),
    .col_names = c("b", "c"),
    .extra_cols = stabilize_present
  )
  expect_identical(result, given)
})

test_that("stabilize_df() preserves data frame class after column coercion (#199)", {
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

test_that("stabilize_df() works with no column specs and .extra_cols (#199)", {
  given <- data.frame(a = 1L, b = "hello")
  result <- stabilize_df(given, .extra_cols = stabilize_present)
  expect_identical(result, given)
})

test_that("stabilize_df() with unnamed specs errors informatively (#199)", {
  expect_error(
    stabilize_df(data.frame(a = 1L), specify_int_scalar()),
    class = .compile_dash("stbl", "error", "unnamed_spec")
  )
})

test_that("stabilise_df() exists (#199)", {
  expect_no_error(stabilise_df(NULL))
})

test_that("stabilize_data_frame() exists (#199)", {
  expect_no_error(stabilize_data_frame(NULL))
})

test_that("stabilise_data_frame() exists (#199)", {
  expect_no_error(stabilise_data_frame(NULL))
})

test_that("specify_df() creates a working validator (#199)", {
  validator <- specify_df(
    name = specify_chr_scalar(),
    age = specify_int_scalar()
  )
  given <- data.frame(name = "Alice", age = 30L)
  expect_identical(validator(given), given)
})

test_that("specify_df() errors when required column is missing (#199)", {
  validator <- specify_df(name = specify_chr_scalar(), age = specify_int_scalar())
  expect_error(
    validator(data.frame(name = "Alice")),
    class = .compile_dash("stbl", "error", "missing_element")
  )
})

test_that("specify_df() passes through .min_rows, .max_rows (#199)", {
  validator <- specify_df(.min_rows = 2, .extra_cols = stabilize_present)
  expect_error(
    validator(data.frame(a = 1L)),
    class = .compile_dash("stbl", "error", "too_few_rows")
  )
})

test_that("specify_df() passes through .col_names (#199)", {
  validator <- specify_df(.col_names = c("a", "b"), .extra_cols = stabilize_present)
  expect_error(
    validator(data.frame(a = 1L)),
    class = .compile_dash("stbl", "error", "missing_cols")
  )
})

test_that("specify_df() allows additional specs via ... (#199)", {
  base_validator <- specify_df(.extra_cols = stabilize_present)
  given <- data.frame(a = 1L, b = "hello")
  result <- base_validator(given, a = specify_int_scalar())
  expect_identical(result, given)
})

test_that("specify_data_frame() exists (#199)", {
  expect_no_error(specify_data_frame())
})
