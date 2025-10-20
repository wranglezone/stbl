test_that("specify_cls builds the expected function with no args", {
  baseline <- specify_cls("chr")
  expect_identical(
    {
      baseline("a")
    },
    "a"
  )
  expect_s3_class(baseline, "stbl_specified_fn")
})

test_that("specify_cls builds the expected function snapshot with no args", {
  skip_on_covr()
  baseline <- specify_cls("chr")
  expect_snapshot(baseline, transform = clean_function_snapshot)
})

test_that("specify_cls builds the expected function with at least one arg", {
  no_null <- specify_cls("chr", allow_null = FALSE)
  expect_identical(
    {
      no_null("a")
    },
    "a"
  )
  expect_pkg_error_classes(
    {
      no_null(NULL)
    },
    "stbl",
    "bad_null"
  )
})

test_that("specify_cls builds the expected function snapshot with at least one arg", {
  skip_on_covr()
  no_null <- specify_cls("chr", allow_null = FALSE)
  expect_snapshot(no_null, transform = clean_function_snapshot)
})

test_that("The function built via specify_cls errors informatively for duplicated args", {
  no_null <- specify_cls("chr", allow_null = FALSE)
  expect_pkg_error_classes(
    {
      no_null(NULL, allow_null = FALSE)
    },
    "stbl",
    "duplicate_args"
  )
  expect_snapshot(
    {
      no_null(NULL, allow_null = FALSE)
    },
    error = TRUE
  )
})

test_that("specify_cls can build a scalar specifier", {
  scalar_checker <- specify_cls("chr", scalar = TRUE)
  given <- "a"
  expect_identical(
    scalar_checker(given),
    given
  )
  expect_pkg_error_classes(
    scalar_checker(c("a", "b")),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_cls builds the expected scalar function snapshot", {
  skip_on_covr()
  scalar_checker <- specify_cls("chr", scalar = TRUE)
  expect_snapshot(scalar_checker, transform = clean_function_snapshot)
})

# Class versions ----

test_that("specify_chr can build a regex checker", {
  regex_checker <- specify_chr(regex = r"(^\d{5}(?:[-\s]\d{4})?$)")
  given <- "12345-6789"
  expect_identical(
    regex_checker(given),
    given
  )
  expect_pkg_error_classes(
    regex_checker("invalid"),
    "stbl",
    "must"
  )
})

test_that("specify_chr_scalar can build a regex checker", {
  regex_checker <- specify_chr_scalar(regex = r"(^\d{5}(?:[-\s]\d{4})?$)")
  given <- "12345-6789"
  expect_identical(
    regex_checker(given),
    given
  )
  expect_pkg_error_classes(
    regex_checker("invalid"),
    "stbl",
    "must"
  )
})

test_that("specify_fct can build a level checker", {
  level_checker <- specify_fct(levels = c("a", "c"), to_na = "b")
  expect_identical(
    level_checker(c("a", "b", "c")),
    factor(c("a", NA, "c"), levels = c("a", "c"))
  )
  expect_pkg_error_classes(
    level_checker("invalid"),
    "stbl",
    "fct_levels"
  )
})

test_that("specify_fct_scalar can build a level checker", {
  level_checker <- specify_fct_scalar(levels = c("a", "c"), to_na = "b")
  expect_identical(
    level_checker("a"),
    factor("a", levels = c("a", "c"))
  )
  expect_pkg_error_classes(
    level_checker(c("a", "c")),
    "stbl",
    "non_scalar"
  )
})
