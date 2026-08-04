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

test_that("stabilize_chr() enforces unique elements (#280)", {
  expect_identical(stabilize_chr(c("a", "b"), unique = TRUE), c("a", "b"))
  expect_pkg_error_classes(
    stabilize_chr(c("a", "b", "a"), unique = TRUE),
    "stbl",
    "duplicate_elements"
  )
})

test_that("stabilize_chr() reports duplicate locations, including NA duplicates (#280)", {
  cnd <- rlang::catch_cnd(stabilize_chr(c("a", "a", NA, NA), unique = TRUE))
  expect_identical(cnd$locations, c(2L, 4L))
})

test_that("stabilize_chr() passes when all elements meet min_characters (#275)", {
  expect_identical(
    stabilize_chr(c("hello", "world"), min_characters = 5),
    c("hello", "world")
  )
  expect_identical(
    stabilize_chr(c("hello", NA), min_characters = 5, allow_na = TRUE),
    c("hello", NA)
  )
})

test_that("stabilize_chr() passes when all elements meet max_characters (#275)", {
  expect_identical(
    stabilize_chr(c("hi", "hey"), max_characters = 3),
    c("hi", "hey")
  )
  expect_identical(
    stabilize_chr(c("hi", NA), max_characters = 3, allow_na = TRUE),
    c("hi", NA)
  )
})

test_that("stabilize_chr() errors when elements have too few characters (#275)", {
  expect_pkg_error_snapshot(
    stabilize_chr(c("hi", "hello"), min_characters = 3),
    "stbl",
    "n_characters",
    "too_few"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_chr(c("hi", "hello"), min_characters = 3),
    "stbl",
    "n_characters",
    "too_few"
  )
})

test_that("stabilize_chr() errors when elements have too many characters (#275)", {
  expect_pkg_error_snapshot(
    stabilize_chr(c("hi", "hello"), max_characters = 3),
    "stbl",
    "n_characters",
    "too_many"
  )
  expect_pkg_error_snapshot(
    wrapped_stabilize_chr(c("hi", "hello"), max_characters = 3),
    "stbl",
    "n_characters",
    "too_many"
  )
})

test_that("stabilize_chr() errors for single element with wrong character count (#275)", {
  expect_pkg_error_snapshot(
    stabilize_chr("hi", min_characters = 5),
    "stbl",
    "n_characters",
    "too_few"
  )
  expect_pkg_error_snapshot(
    stabilize_chr("hello", max_characters = 3),
    "stbl",
    "n_characters",
    "too_many"
  )
})

test_that("stabilize_chr() errors when both min and max fail (#275)", {
  expect_pkg_error_snapshot(
    stabilize_chr(
      c("a", "hello_world"),
      min_characters = 2,
      max_characters = 5
    ),
    "stbl",
    "n_characters"
  )
})

test_that("stabilize_chr() errors when min_characters > max_characters (#275)", {
  expect_pkg_error_snapshot(
    stabilize_chr("hello", min_characters = 5, max_characters = 3),
    "stbl",
    "size_x_vs_y"
  )
})

test_that("stabilize_chr() attaches locations for min/max_characters failures (#275)", {
  cnd <- rlang::catch_cnd(
    stabilize_chr(c("hi", "hello"), min_characters = 3)
  )
  expect_identical(cnd$locations, 1L)

  cnd <- rlang::catch_cnd(
    stabilize_chr(c("hi", "hello"), max_characters = 3)
  )
  expect_identical(cnd$locations, 2L)
})

test_that("stabilize_chr_scalar() errors for wrong character count (#275)", {
  expect_pkg_error_snapshot(
    stabilize_chr_scalar("hi", min_characters = 5),
    "stbl",
    "n_characters",
    "too_few"
  )
  expect_pkg_error_snapshot(
    stabilize_chr_scalar("hello", max_characters = 3),
    "stbl",
    "n_characters",
    "too_many"
  )
})
