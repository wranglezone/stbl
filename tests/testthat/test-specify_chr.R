test_that("specify_chr builds the expected factory", {
  baseline <- specify_chr()
  expect_identical(baseline("a"), "a")
  expect_s3_class(baseline, "stbl_specified_fn")

  given <- "12345-6789"
  pattern <- r"(^\d{5}(?:[-\s]\d{4})?$)"
  regex_checker <- specify_chr(regex = pattern)
  expect_identical(
    regex_checker(given),
    given
  )
  expect_pkg_error_classes(
    regex_checker("invalid"),
    "stbl",
    "must"
  )

  no_null <- specify_chr(allow_null = FALSE)
  expect_pkg_error_classes(
    no_null(NULL),
    "stbl",
    "bad_null"
  )
})

test_that("specify_chr passes dots", {
  baseline <- specify_chr()
  expect_pkg_error_classes(
    baseline(NULL, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})
