test_that("specify_chr can build a regex checker (#147, #310, #325)", {
  checker <- specify_chr(regex = r"(^\d{5}(?:[-\s]\d{4})?$)")
  given <- "12345-6789"
  expect_identical(
    checker(given),
    given
  )
  expect_pkg_error_classes(
    checker("invalid"),
    "stbl",
    "regex_mismatch"
  )
})

test_that("specify_chr can enforce unique elements (#280, #325)", {
  checker <- specify_chr(unique = TRUE)
  expect_identical(checker(c("a", "b")), c("a", "b"))
  expect_pkg_error_classes(
    checker(c("a", "b", "a")),
    "stbl",
    "duplicate_elements"
  )
})

test_that("specify_chr_scalar can build a regex checker (#147, #310, #325)", {
  checker <- specify_chr_scalar(regex = r"(^\d{5}(?:[-\s]\d{4})?$)")
  given <- "12345-6789"
  expect_identical(
    checker(given),
    given
  )
  expect_pkg_error_classes(
    checker("invalid"),
    "stbl",
    "regex_mismatch"
  )
})

test_that("specify_chr_scalar defaults to allow_null = FALSE (#197, #325)", {
  checker <- specify_chr_scalar()
  expect_pkg_error_classes(checker(NULL), "stbl", "bad_null")
  expect_identical(checker(NULL, allow_null = TRUE), NULL)
})

test_that("specify_chr_scalar defaults to allow_zero_length = FALSE (#197, #325)", {
  checker <- specify_chr_scalar()
  expect_pkg_error_classes(checker(character(0)), "stbl", "bad_empty")
  expect_identical(
    checker(character(0), allow_zero_length = TRUE),
    character(0)
  )
})

test_that("specify_character() exists (#164, #325)", {
  expect_no_error(specify_character())
})

test_that("stabilize_character_scalar() exists (#164, #325)", {
  expect_no_error(specify_character_scalar())
})

test_that("specify_chr can enforce allowed_values (#282, #325)", {
  checker <- specify_chr(allowed_values = c("a", "b"))
  expect_identical(checker("a"), "a")
  expect_pkg_error_classes(checker("z"), "stbl", "allowed_values")
})
