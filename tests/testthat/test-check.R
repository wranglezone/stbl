test_that(".check_na() works (#95)", {
  expect_null(.check_na(1))
  expect_null(.check_na(NA))
  expect_null(.check_na(c(1, 2), allow_na = FALSE))
  expect_pkg_error_classes(
    .check_na(c(1, NA), allow_na = FALSE),
    "stbl",
    "bad_na"
  )
  expect_snapshot(
    .check_na(c(1, NA), allow_na = FALSE),
    error = TRUE
  )
})

test_that(".check_size() works (#95)", {
  expect_null(.check_size(1:5, NULL, NULL))
  expect_null(.check_size(1:5, 1, 10))
  expect_pkg_error_classes(.check_size(1:5, 6, 10), "stbl", "size_too_small")
  expect_snapshot(.check_size(1:5, 6, 10), error = TRUE)
  expect_pkg_error_classes(.check_size(1:5, 1, 4), "stbl", "size_too_large")
  expect_snapshot(.check_size(1:5, 1, 4), error = TRUE)
})

test_that(".check_scalar() works (#95)", {
  expect_null(.check_scalar(1))
  expect_null(.check_scalar(NULL))
  expect_null(.check_scalar(character()))
  expect_pkg_error_classes(.check_scalar(1:2), "stbl", "non_scalar")
  expect_snapshot(.check_scalar(1:2), error = TRUE)
  expect_pkg_error_classes(
    .check_scalar(NULL, allow_null = FALSE),
    "stbl",
    "non_scalar"
  )
  expect_snapshot(.check_scalar(NULL, allow_null = FALSE), error = TRUE)
  expect_pkg_error_classes(
    .check_scalar(character(), allow_zero_length = FALSE),
    "stbl",
    "bad_empty"
  )
  expect_snapshot(
    .check_scalar(character(), allow_zero_length = FALSE),
    error = TRUE
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
  expect_pkg_error_classes(.check_x_no_more_than_y(2, 1), "stbl", "size_x_vs_y")
  expect_snapshot(.check_x_no_more_than_y(2, 1), error = TRUE)
})

test_that(".check_cast_failures() works", {
  # Happy path
  expect_null(
    .check_cast_failures(
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
  expect_pkg_error_classes(
    .check_cast_failures(
      failures = failures,
      x_class = "character",
      to = logical(),
      due_to = "incompatible values",
      x_arg = "test_arg",
      call = rlang::current_env()
    ),
    "stbl",
    "incompatible_type"
  )

  expect_snapshot(
    .check_cast_failures(
      failures = failures,
      x_class = "character",
      to = logical(),
      due_to = "incompatible values",
      x_arg = "test_arg",
      call = rlang::current_env()
    ),
    error = TRUE
  )
})

test_that(".check_all_named() works (#203)", {
  expect_null(.check_all_named(list(a = 1, b = 2)))
  expect_pkg_error_classes(.check_all_named(list(1, 2)), "stbl", "bad_named")
  expect_snapshot(
    .check_all_named(list(1, 2)),
    error = TRUE
  )
})

test_that(".check_not_jagged() works (#203)", {
  expect_null(.check_not_jagged(list()))
  expect_null(.check_not_jagged(list(a = 1, b = 2)))
  expect_null(.check_not_jagged(list(a = 1:3, b = 1:3)))
  expect_pkg_error_classes(
    .check_not_jagged(list(a = 1:3, b = 1:2)),
    "stbl",
    "jagged"
  )
  expect_snapshot(
    .check_not_jagged(list(a = 1:3, b = 1:2)),
    error = TRUE
  )
})
