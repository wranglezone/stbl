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

test_that("stabilize_chr() errors for bad regex matches (#27, #52)", {
  given <- c("123456789", "12345-6789")
  pattern <- r"(^\d{5}(?:[-\s]\d{4})?$)"
  expect_error(
    stabilize_chr(given, regex = pattern),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    stabilize_chr(given, regex = pattern),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_chr(given, regex = pattern),
    error = TRUE
  )
})

test_that("stabilize_chr() works with complex url regex (#52)", {
  skip_if_not_installed("stringi")
  url_regex <- r"(^(?:(?:(?:https?|ftp):)?\/\/)?(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u00a1-\uffff][a-z0-9\u00a1-\uffff_-]{0,62})?[a-z0-9\u00a1-\uffff]\.)+(?:[a-z\u00a1-\uffff]{2,}\.?))(?::\d{2,5})?(?:[/?#]\S*)?$)"
  expect_snapshot(
    stabilize_chr(
      "example.com",
      regex = url_regex
    )
  )
  expect_error(
    stabilize_chr(
      c("example.com", "not a url"),
      regex = url_regex
    ),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    stabilize_chr(
      c("example.com", "not a url"),
      regex = url_regex
    ),
    error = TRUE
  )
})

test_that("stabilize_chr() allows for customized error messages (#52)", {
  skip_if_not_installed("stringi")
  url_regex <- r"(^(?:(?:(?:https?|ftp):)?\/\/)?(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u00a1-\uffff][a-z0-9\u00a1-\uffff_-]{0,62})?[a-z0-9\u00a1-\uffff]\.)+(?:[a-z\u00a1-\uffff]{2,}\.?))(?::\d{2,5})?(?:[/?#]\S*)?$)"
  expect_error(
    stabilize_chr(
      c("not a url", "example.com"),
      regex = c("must be a url." = url_regex)
    ),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    stabilize_chr(
      c("not a url", "example.com"),
      regex = c("must be a url." = url_regex)
    ),
    error = TRUE
  )
})

test_that("stabilize_chr() works with regex that contains braces (#52)", {
  expect_error(
    stabilize_chr(c("b", "aa"), regex = "a{1,3}"),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    stabilize_chr(c("b", "aa"), regex = "a{1,3}"),
    error = TRUE
  )
})

test_that("stabilize_chr() accepts negated regex args (#85)", {
  given <- c("a", "b")
  regex <- "c"
  attr(regex, "negate") <- TRUE
  expect_identical(
    stabilize_chr(given, regex = regex),
    given
  )

  given <- c("a", "b", "c")
  expect_error(
    stabilize_chr(given, regex = regex),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    stabilize_chr(given, regex = regex),
    error = TRUE
  )
})

test_that("stabilize_chr() accepts multiple regex rules (#86, #85)", {
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
  expect_error(
    stabilize_chr(given, regex = rules),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    stabilize_chr(given, regex = rules),
    error = TRUE
  )
})

test_that("stabilize_chr() works with stringr::fixed() (#87)", {
  skip_if_not_installed("stringr")
  expect_identical(
    stabilize_chr("a.b", regex = stringr::fixed("a.b")),
    "a.b"
  )
  expect_error(
    stabilize_chr(c("a.b", "acb"), regex = stringr::fixed("a.b")),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    stabilize_chr(c("a.b", "acb"), regex = stringr::fixed("a.b")),
    error = TRUE
  )
})

test_that("stabilize_chr() works with stringr::coll() (#87)", {
  skip_if_not_installed("stringr")
  expect_identical(
    stabilize_chr("A", regex = stringr::coll("a", ignore_case = TRUE)),
    "A"
  )
  expect_error(
    stabilize_chr(c("a", "A"), regex = stringr::coll("a")),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    stabilize_chr(c("a", "A"), regex = stringr::coll("a")),
    error = TRUE
  )
})

test_that("stabilize_chr() works with stringr::regex() (#87)", {
  skip_if_not_installed("stringr")
  expect_identical(
    stabilize_chr("A", regex = stringr::regex("a", ignore_case = TRUE)),
    "A"
  )
  expect_error(
    stabilize_chr(c("A", "B"), regex = stringr::regex("a", ignore_case = TRUE)),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    stabilize_chr(c("A", "B"), regex = stringr::regex("a", ignore_case = TRUE)),
    error = TRUE
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
  expect_error(
    {
      stabilize_chr(
        c("abc", NA),
        allow_na = FALSE,
        regex = "^[A-Za-z]+$"
      )
    },
    class = .compile_dash("stbl", "error", "bad_na")
  )
})

test_that("stabilize_chr_scalar() allows length-1 chrs through (#22)", {
  expect_identical(stabilize_chr_scalar("a"), "a")
})

test_that("stabilize_chr_scalar() errors for non-scalars (#22)", {
  given <- letters
  expect_error(
    stabilize_chr_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    stabilize_chr_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_chr_scalar(given),
    error = TRUE
  )
})

test_that("stabilize_chr_scalar() works with regex that contains braces (#52)", {
  expect_error(
    stabilize_chr_scalar("b", regex = "a{1,3}"),
    class = .compile_dash("stbl", "error", "must")
  )
  expect_snapshot(
    stabilize_chr_scalar("b", regex = "a{1,3}"),
    error = TRUE
  )
})
