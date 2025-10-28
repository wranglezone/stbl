test_that("specify_cls builds the expected function with no args (#150)", {
  baseline <- specify_cls("chr")
  expect_identical(
    {
      baseline("a")
    },
    "a"
  )
  expect_s3_class(baseline, "stbl_specified_fn")
})

test_that("specify_cls builds the expected function snapshot with no args (#150)", {
  skip_on_covr()
  baseline <- specify_cls("chr")
  expect_snapshot(baseline, transform = clean_function_snapshot)
})

test_that("specify_cls builds the expected function with at least one arg (#150, #161)", {
  no_null <- specify_cls("chr", list(allow_null = FALSE))
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

test_that("specify_cls builds the expected function snapshot with at least one arg (#150, #161)", {
  skip_on_covr()
  no_null <- specify_cls("chr", list(allow_null = FALSE))
  expect_snapshot(no_null, transform = clean_function_snapshot)
})

test_that("The function built via specify_cls errors informatively for duplicated args (#150, #161)", {
  no_null <- specify_cls("chr", list(allow_null = FALSE))
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

test_that("specify_cls can build a scalar specifier (#150)", {
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

test_that("specify_cls builds the expected scalar function snapshot (#150)", {
  skip_on_covr()
  scalar_checker <- specify_cls("chr", scalar = TRUE)
  expect_snapshot(scalar_checker, transform = clean_function_snapshot)
})

# Class versions ----

test_that("specify_chr can build a regex checker (#147)", {
  checker <- specify_chr(regex = r"(^\d{5}(?:[-\s]\d{4})?$)")
  given <- "12345-6789"
  expect_identical(
    checker(given),
    given
  )
  expect_pkg_error_classes(
    checker("invalid"),
    "stbl",
    "must"
  )
})

test_that("specify_chr_scalar can build a regex checker (#147)", {
  checker <- specify_chr_scalar(regex = r"(^\d{5}(?:[-\s]\d{4})?$)")
  given <- "12345-6789"
  expect_identical(
    checker(given),
    given
  )
  expect_pkg_error_classes(
    checker("invalid"),
    "stbl",
    "must"
  )
})

test_that("specify_dbl can build a value checker (#148)", {
  checker <- specify_dbl(min_value = 27.2)
  expect_identical(
    checker(30:40 + 0.1),
    30:40 + 0.1
  )
  expect_pkg_error_classes(
    checker(19.2),
    "stbl",
    "outside_range"
  )
})

test_that("specify_dbl_scalar can build a value checker (#148)", {
  checker <- specify_dbl_scalar(min_value = 27.2)
  expect_identical(
    checker(30.1),
    30.1
  )
  expect_pkg_error_classes(
    checker(30:40 + 0.1),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_fct can build a level checker (#150)", {
  checker <- specify_fct(levels = c("a", "c"), to_na = "b")
  expect_identical(
    checker(c("a", "b", "c")),
    factor(c("a", NA, "c"), levels = c("a", "c"))
  )
  expect_pkg_error_classes(
    checker("invalid"),
    "stbl",
    "fct_levels"
  )
})

test_that("specify_fct_scalar can build a level checker (#150)", {
  checker <- specify_fct_scalar(levels = c("a", "c"), to_na = "b")
  expect_identical(
    checker("a"),
    factor("a", levels = c("a", "c"))
  )
  expect_pkg_error_classes(
    checker(c("a", "c")),
    "stbl",
    "non_scalar"
  )
})

test_that("specify_int can build a value checker (#149)", {
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

test_that("specify_int_scalar can build a value checker (#149)", {
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

test_that("specify_lgl can build a checker (#151)", {
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

test_that("specify_lgl_scalar can build a value checker (#151)", {
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
