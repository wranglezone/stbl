test_that(".specify_cls builds the expected function with no args (#150)", {
  baseline <- .specify_cls("chr")
  expect_identical(
    {
      baseline("a")
    },
    "a"
  )
  expect_s3_class(baseline, "stbl_specified_fn")
})

test_that(".specify_cls builds the expected function snapshot with no args (#150)", {
  baseline <- .specify_cls("chr")
  expect_snapshot(baseline, transform = clean_function_snapshot)
})

test_that(".specify_cls builds the expected function with at least one arg (#150, #161)", {
  no_null <- .specify_cls("chr", list(allow_null = FALSE))
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

test_that(".specify_cls builds the expected function snapshot with at least one arg (#150, #161)", {
  no_null <- .specify_cls("chr", list(allow_null = FALSE))
  expect_snapshot(no_null, transform = clean_function_snapshot)
})

test_that("The function built via .specify_cls errors informatively for duplicated args (#150, #153, #161)", {
  no_null <- .specify_cls("chr", list(allow_null = FALSE))
  expect_pkg_error_snapshot(
    {
      no_null(NULL, allow_null = FALSE)
    },
    "stbl",
    "duplicate_args"
  )
})

test_that(".specify_cls can build a scalar specifier (#150)", {
  scalar_checker <- .specify_cls("chr", scalar = TRUE)
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

test_that(".specify_cls builds the expected scalar function snapshot (#150)", {
  scalar_checker <- .specify_cls("chr", scalar = TRUE)
  expect_snapshot(scalar_checker, transform = clean_function_snapshot)
})

test_that(".capture_factory_args only includes non-missing arguments (#325)", {
  spec <- function(a = 1, b = 2, c = 3) {
    .capture_factory_args()
  }
  expect_identical(spec(a = 10, c = 30), list(a = 10, c = 30))
  expect_identical(spec(), list())
})
