# stabilize_names ----

test_that("stabilize_names() returns x unchanged by default (#26)", {
  given <- c(a = 1, b = 2)
  expect_identical(stabilize_names(given), given)
  expect_identical(stabilize_names(1:2), 1:2)
  expect_null(stabilize_names(NULL))
})

test_that("stabilize_names() leaves the class and values of x alone (#26)", {
  given <- factor(c(a = "x", b = "y"))
  expect_identical(stabilize_names(given), given)
  given <- structure(list(a = 1, b = 2), class = "my_class")
  expect_identical(stabilize_names(given), given)
})

test_that("stabilize_names() rejects duplicate names by default (#26)", {
  given <- c(a = 1, a = 2)
  expect_pkg_error_snapshot(stabilize_names(given), "stbl", "duplicate_names")
  expect_identical(
    stabilize_names(given, allow_duplicate_names = TRUE),
    given
  )
})

test_that("stabilize_names() ignores empty names for duplicates (#26)", {
  given <- c(a = 1, 2, 3)
  expect_identical(stabilize_names(given), given)
})

test_that("stabilize_names() requires names to be present (#26)", {
  given <- c(a = 1, b = 2)
  expect_identical(stabilize_names(given, required = "a"), given)
  expect_pkg_error_snapshot(
    stabilize_names(given, required = c("a", "c", "d")),
    "stbl",
    "missing_element"
  )
  expect_pkg_error_classes(
    stabilize_names(1:2, required = "a"),
    "stbl",
    "missing_element"
  )
  expect_identical(stabilize_names(given, required = NULL), given)
  expect_identical(stabilize_names(given, required = character()), given)
})

test_that("stabilize_names() restricts names to allowed_names (#26)", {
  given <- c(a = 1, b = 2)
  expect_identical(stabilize_names(given, allowed_names = c("a", "b")), given)
  expect_pkg_error_classes(
    stabilize_names(given, allowed_names = "a"),
    "stbl",
    "allowed_names"
  )
  expect_pkg_error_classes(
    stabilize_names(1:2, allowed_names = "a"),
    "stbl",
    "bad_named"
  )
})

test_that("stabilize_names() applies spec to the names (#26)", {
  given <- c(a = 1, b = 2)
  expect_identical(
    stabilize_names(given, spec = toupper),
    c(A = 1, B = 2)
  )
  expect_identical(
    stabilize_names(given, spec = specify_chr(regex = "^[a-z]$")),
    given
  )
  expect_pkg_error_classes(
    stabilize_names(given, spec = specify_chr(regex = "^[A-Z]$")),
    "stbl",
    "regex_mismatch"
  )
  expect_pkg_error_classes(
    stabilize_names(1:2, spec = to_chr),
    "stbl",
    "bad_named"
  )
  expect_identical(stabilize_names(integer(), spec = toupper), integer())
})

test_that("stabilize_names() checks duplicates after spec conversion (#26)", {
  expect_pkg_error_classes(
    stabilize_names(c(a = 1, A = 2), spec = tolower),
    "stbl",
    "duplicate_names"
  )
})

test_that("stabilize_names() checks required after spec conversion (#26)", {
  expect_identical(
    stabilize_names(c(a = 1), spec = toupper, required = "A"),
    c(A = 1)
  )
})

test_that("stabilize_names() reports x_arg in errors (#26)", {
  my_x <- c(a = 1, a = 2)
  expect_pkg_error_snapshot(stabilize_names(my_x), "stbl", "duplicate_names")
})

test_that("stabilise_names() is a synonym (#26)", {
  expect_identical(stabilise_names, stabilize_names)
})

test_that("stabilize_names() rejects unused arguments in ... (#26)", {
  expect_error(stabilize_names(c(a = 1), "a"), class = "rlang_error")
})
