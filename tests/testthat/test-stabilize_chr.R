test_that("stabilize_chr() works on happy path (#22, #27, #52)", {
  expect_identical(stabilize_chr("a"), "a")

  given <- "12345-6789"
  pattern <- r"(^\d{5}(?:[-\s]\d{4})?$)"
  expect_identical(
    stabilize_chr(
      given,
      regex = pattern
    ),
    given
  )
})

test_that("stabilize_chr() errors for bad regex matches (#27, #52, #310)", {
  given <- c("123456789", "12345-6789")
  pattern <- r"(^\d{5}(?:[-\s]\d{4})?$)"
  expect_pkg_error_snapshot(
    stabilize_chr(given, regex = pattern),
    "stbl",
    "regex_mismatch"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_chr(given, regex = pattern),
    "stbl",
    "regex_mismatch"
  )
})

test_that("stabilize_chr() works with complex url regex (#52, #310)", {
  skip_if_not_installed("stringi")
  url_regex <- r"(^(?:(?:(?:https?|ftp):)?\/\/)?(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u00a1-\uffff][a-z0-9\u00a1-\uffff_-]{0,62})?[a-z0-9\u00a1-\uffff]\.)+(?:[a-z\u00a1-\uffff]{2,}\.?))(?::\d{2,5})?(?:[/?#]\S*)?$)"
  expect_snapshot(
    stabilize_chr(
      "example.com",
      regex = url_regex
    )
  )
  expect_pkg_error_snapshot(
    stabilize_chr(
      c("example.com", "not a url"),
      regex = url_regex
    ),
    "stbl",
    "regex_mismatch"
  )
})

test_that("stabilize_chr() allows for customized error messages (#52, #310)", {
  skip_if_not_installed("stringi")
  url_regex <- r"(^(?:(?:(?:https?|ftp):)?\/\/)?(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u00a1-\uffff][a-z0-9\u00a1-\uffff_-]{0,62})?[a-z0-9\u00a1-\uffff]\.)+(?:[a-z\u00a1-\uffff]{2,}\.?))(?::\d{2,5})?(?:[/?#]\S*)?$)"
  expect_pkg_error_snapshot(
    stabilize_chr(
      c("not a url", "example.com"),
      regex = c("must be a url." = url_regex)
    ),
    "stbl",
    "regex_mismatch"
  )
})

test_that("stabilize_chr() works with regex that contains braces (#52, #310)", {
  expect_pkg_error_snapshot(
    stabilize_chr(c("b", "aa"), regex = "a{1,3}"),
    "stbl",
    "regex_mismatch"
  )
})

test_that("stabilize_chr() accepts negated regex args (#85, #310)", {
  given <- c("a", "b")
  regex <- "c"
  attr(regex, "negate") <- TRUE
  expect_identical(
    stabilize_chr(given, regex = regex),
    given
  )

  given <- c("a", "b", "c")
  expect_pkg_error_snapshot(
    stabilize_chr(given, regex = regex),
    "stbl",
    "regex_mismatch"
  )
})

test_that("stabilize_chr() accepts multiple regex rules (#86, #85, #310)", {
  rules <- list(
    regex_must_match("a"),
    regex_must_not_match("b")
  )
  given <- c("apple", "avocado")
  expect_identical(
    stabilize_chr(given, regex = rules),
    given
  )
  given <- c("apple", "banana", "boat", "plum")
  expect_pkg_error_snapshot(
    stabilize_chr(given, regex = rules),
    "stbl",
    "regex_mismatch"
  )
})

test_that("stabilize_chr() works with stringr::fixed() (#87, #310)", {
  skip_if_not_installed("stringr")
  expect_identical(
    stabilize_chr("a.b", regex = stringr::fixed("a.b")),
    "a.b"
  )
  expect_pkg_error_snapshot(
    stabilize_chr(c("a.b", "acb"), regex = stringr::fixed("a.b")),
    "stbl",
    "regex_mismatch"
  )
})

test_that("stabilize_chr() works with stringr::coll() (#87, #310)", {
  skip_if_not_installed("stringr")
  expect_identical(
    stabilize_chr("A", regex = stringr::coll("a", ignore_case = TRUE)),
    "A"
  )
  expect_pkg_error_snapshot(
    stabilize_chr(c("a", "A"), regex = stringr::coll("a")),
    "stbl",
    "regex_mismatch"
  )
})

test_that("stabilize_chr() works with stringr::regex() (#87, #310)", {
  skip_if_not_installed("stringr")
  expect_identical(
    stabilize_chr("A", regex = stringr::regex("a", ignore_case = TRUE)),
    "A"
  )
  expect_pkg_error_snapshot(
    stabilize_chr(c("A", "B"), regex = stringr::regex("a", ignore_case = TRUE)),
    "stbl",
    "regex_mismatch"
  )
})

test_that("stabilize_chr works with NA and regex pattern (#27, #52)", {
  expect_no_error({
    stabilize_chr(
      c("abc", NA),
      allow_na = TRUE,
      regex = "^[A-Za-z]+$"
    )
  })
  expect_pkg_error_classes(
    {
      stabilize_chr(
        c("abc", NA),
        allow_na = FALSE,
        regex = "^[A-Za-z]+$"
      )
    },
    "stbl",
    "bad_na"
  )
})

test_that("stabilize_chr_scalar() allows length-1 chrs through (#22, #189)", {
  expect_identical(stabilize_chr_scalar("a"), "a")
  expect_null(stabilize_chr_scalar(NULL, allow_null = TRUE))
})

test_that("stabilize_chr_scalar() respects allow_null (#22, #189)", {
  given <- NULL
  expect_pkg_error_snapshot(stabilize_chr_scalar(given), "stbl", "bad_null")
  expect_pkg_error_snapshot(
    wrapped_stabilize_chr_scalar(given),
    "stbl",
    "bad_null"
  )
})

test_that("stabilize_chr_scalar() errors for non-scalars (#22)", {
  given <- letters
  expect_pkg_error_snapshot(stabilize_chr_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    wrapped_stabilize_chr_scalar(given),
    "stbl",
    "non_scalar"
  )
})

test_that("stabilize_chr_scalar() works with regex that contains braces (#52, #310)", {
  expect_pkg_error_snapshot(
    stabilize_chr_scalar("b", regex = "a{1,3}"),
    "stbl",
    "regex_mismatch"
  )
})

test_that("stabilize_chr() and stabilize_chr_scalar() work when x is a function (#noissue)", {
  expect_identical(stabilize_chr(mean), "base::mean")
  expect_identical(stabilize_chr_scalar(mean), "base::mean")
})

test_that("stabilise_chr() exists (#167)", {
  expect_no_error(stabilise_chr(TRUE))
})

test_that("stabilize_character() exists (#164)", {
  expect_no_error(stabilize_character(TRUE))
})

test_that("stabilise_character() exists (#167)", {
  expect_no_error(stabilise_character(TRUE))
})

test_that("stabilise_chr_scalar() exists (#167)", {
  expect_no_error(stabilise_chr_scalar(TRUE))
})

test_that("stabilize_character_scalar() exists (#164)", {
  expect_no_error(stabilize_character_scalar(TRUE))
})

test_that("stabilise_character_scalar() exists (#167)", {
  expect_no_error(stabilise_character_scalar(TRUE))
})

test_that("stabilize_chr() attaches regex failure locations (#274)", {
  cnd <- rlang::catch_cnd(
    stabilize_chr(c("hide", "find", "find", "hide"), regex = "hide")
  )
  expect_identical(cnd$locations, c(2L, 3L))
})
