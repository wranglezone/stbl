test_that(".check_na() works (#95)", {
  expect_null(.check_na(1))
  expect_null(.check_na(NA))
  expect_null(.check_na(c(1, 2), allow_na = FALSE))
  expect_pkg_error_snapshot(
    .check_na(c(1, NA), allow_na = FALSE),
    "stbl",
    "bad_na"
  )
})

test_that(".check_na() attaches failing locations (#274)", {
  cnd <- rlang::catch_cnd(.check_na(c(1, NA, 3, NA), allow_na = FALSE))
  expect_identical(cnd$locations, c(2L, 4L))
})

test_that(".check_size() works (#95)", {
  expect_null(.check_size(1:5, NULL, NULL))
  expect_null(.check_size(1:5, 1, 10))
  expect_pkg_error_snapshot(.check_size(1:5, 6, 10), "stbl", "size_too_small")
  expect_pkg_error_snapshot(.check_size(1:5, 1, 4), "stbl", "size_too_large")
})

test_that(".check_unique() works for atomic and list inputs (#280)", {
  expect_null(.check_unique(c(1, 2), unique = FALSE))
  expect_null(.check_unique(c(1, 2), unique = TRUE))
  expect_pkg_error_classes(
    .check_unique(c(1, 2, 1), unique = TRUE),
    "stbl",
    "duplicate_elements"
  )
  expect_pkg_error_classes(
    .check_unique(list(1, 2, 1), unique = TRUE),
    "stbl",
    "duplicate_elements"
  )
})

test_that(".check_allowed_values() works (#282)", {
  expect_null(.check_allowed_values(c("a", "b"), NULL))
  expect_null(.check_allowed_values(c("a", "b"), character()))
  expect_null(.check_allowed_values(c("a", "b"), c("a", "b", "c")))
  expect_pkg_error_snapshot(
    .check_allowed_values(c("a", "b", "z"), c("a", "b", "c")),
    "stbl",
    "allowed_values"
  )
})

test_that(".check_allowed_values() permits NA independently of allowed_values (#282)", {
  expect_null(.check_allowed_values(c("a", NA), c("a")))
})

test_that(".check_allowed_values() attaches failing locations (#282)", {
  cnd <- rlang::catch_cnd(
    .check_allowed_values(c("a", "b", "z", "y"), c("a", "b"))
  )
  expect_identical(cnd$locations, c(3L, 4L))
})

test_that(".check_scalar() works (#95)", {
  expect_null(.check_scalar(1))
  expect_null(.check_scalar(NULL))
  expect_null(.check_scalar(character()))
  expect_pkg_error_snapshot(.check_scalar(1:2), "stbl", "non_scalar")
  expect_pkg_error_snapshot(
    .check_scalar(NULL, allow_null = FALSE),
    "stbl",
    "non_scalar"
  )
  expect_pkg_error_snapshot(
    .check_scalar(character(), allow_zero_length = FALSE),
    "stbl",
    "bad_empty"
  )
})

test_that(".is_allowed_null() checks whether value is NULL and ok", {
  wrapper <- function(wrapper_val, ...) {
    return(.is_allowed_null(wrapper_val, ...))
  }

  given <- NULL
  expect_true(.is_allowed_null(given))
  expect_true(wrapper(given))
  expect_false(.is_allowed_null(given, allow_null = FALSE))
  expect_false(wrapper(given, allow_null = FALSE))
})

test_that(".check_x_no_more_than_y() works (#95)", {
  expect_null(.check_x_no_more_than_y(1, 2))
  expect_null(.check_x_no_more_than_y(2, 2))
  expect_null(.check_x_no_more_than_y(NULL, 2))
  expect_null(.check_x_no_more_than_y(1, NULL))
  expect_pkg_error_snapshot(
    .check_x_no_more_than_y(2, 1),
    "stbl",
    "size_x_vs_y"
  )
})

test_that(".check_cast_failures() works (#310, #332)", {
  # Happy path
  expect_null(
    .check_cast_failures(
      x = c("a", "b"),
      failures = c(FALSE, FALSE),
      x_class = "character",
      to = logical(),
      due_to = "incompatible values",
      x_arg = "test_arg",
      call = rlang::current_env()
    )
  )

  # Failure path
  failures <- c(FALSE, TRUE, FALSE, TRUE)
  expect_pkg_error_snapshot(
    .check_cast_failures(
      x = c("a", "b", "c", "d"),
      failures = failures,
      x_class = "character",
      to = logical(),
      due_to = "incompatible values",
      x_arg = "test_arg",
      call = rlang::current_env()
    ),
    "stbl",
    "incompatible_values",
    "logical"
  )
})

test_that(".check_cast_failures() attaches failing locations and values (#274, #332)", {
  cnd <- rlang::catch_cnd(
    .check_cast_failures(
      x = c("a", "b", "c", "d"),
      failures = c(FALSE, TRUE, FALSE, TRUE),
      x_class = "character",
      to = logical(),
      due_to = "incompatible values",
      x_arg = "test_arg",
      call = rlang::current_env()
    )
  )
  expect_identical(cnd$locations, c(2L, 4L))
  expect_identical(cnd$values, c("b", "d"))
})

test_that(".check_all_named() works (#203)", {
  expect_null(.check_all_named(list(a = 1, b = 2)))
  expect_pkg_error_snapshot(.check_all_named(list(1, 2)), "stbl", "bad_named")
})

test_that(".check_not_jagged() works (#203)", {
  expect_null(.check_not_jagged(list()))
  expect_null(.check_not_jagged(list(a = 1, b = 2)))
  expect_null(.check_not_jagged(list(a = 1:3, b = 1:3)))
  expect_pkg_error_snapshot(
    .check_not_jagged(list(a = 1:3, b = 1:2)),
    "stbl",
    "jagged"
  )
})

test_that(".check_not_jagged() attaches failing locations (#274)", {
  cnd <- rlang::catch_cnd(
    .check_not_jagged(list(a = 1:3, b = 1:3, c = 1:2))
  )
  expect_identical(cnd$locations, 3L)
})

test_that(".check_multiple_of() works (#283)", {
  expect_null(.check_multiple_of(c(2, 4, 6), NULL))
  expect_null(.check_multiple_of(c(2, 4, 6), 2))
  expect_pkg_error_snapshot(
    .check_multiple_of(c(2, 3, 6), 2),
    "stbl",
    "not_multiple"
  )
})

test_that(".check_multiple_of() permits NA independently of multiple_of (#283)", {
  expect_null(.check_multiple_of(c(2, NA, 6), 2))
})

test_that(".check_multiple_of() rejects a non-positive multiple_of (#283)", {
  expect_pkg_error_snapshot(
    .check_multiple_of(c(2, 4), 0),
    "stbl",
    "bad_multiple_of"
  )
  expect_pkg_error_snapshot(
    .check_multiple_of(c(2, 4), -2),
    "stbl",
    "bad_multiple_of"
  )
})

test_that(".check_multiple_of() tolerates floating-point rounding error (#283)", {
  expect_null(.check_multiple_of(c(0.3, 0.6, 0.9), 0.3))
  expect_null(.check_multiple_of(seq(0, 1, by = 0.1), 0.1))
})

test_that(".check_multiple_of() attaches failing locations (#283)", {
  cnd <- rlang::catch_cnd(.check_multiple_of(c(2, 3, 6, 7), 2))
  expect_identical(cnd$locations, c(2L, 4L))
})

test_that("object-level checks do not attach locations (#274)", {
  expect_null(rlang::catch_cnd(.check_size(1:5, 6, 10))$locations)
  expect_null(rlang::catch_cnd(.check_scalar(1:2))$locations)
  expect_null(rlang::catch_cnd(.check_all_named(list(1, 2)))$locations)
  expect_null(rlang::catch_cnd(.check_x_no_more_than_y(2, 1))$locations)
})
