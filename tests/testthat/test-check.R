test_that(".check_na() works", {
  expect_null(.check_na(1))
  expect_null(.check_na(NA))
  expect_null(.check_na(c(1, 2), allow_na = FALSE))
  expect_error(
    .check_na(c(1, NA), allow_na = FALSE),
    class = .compile_dash("stbl", "error", "bad_na")
  )
  expect_snapshot(
    .check_na(c(1, NA), allow_na = FALSE),
    error = TRUE
  )
})

test_that(".check_size() works", {
  expect_null(.check_size(1:5, NULL, NULL))
  expect_null(.check_size(1:5, 1, 10))
  expect_error(
    .check_size(1:5, 6, 10),
    class = .compile_dash("stbl", "error", "size_too_small")
  )
  expect_snapshot(.check_size(1:5, 6, 10), error = TRUE)
  expect_error(
    .check_size(1:5, 1, 4),
    class = .compile_dash("stbl", "error", "size_too_large")
  )
  expect_snapshot(.check_size(1:5, 1, 4), error = TRUE)
})

test_that(".check_scalar() works", {
  expect_null(.check_scalar(1))
  expect_null(.check_scalar(NULL))
  expect_null(.check_scalar(character()))
  expect_error(
    .check_scalar(1:2),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(.check_scalar(1:2), error = TRUE)
  expect_error(
    .check_scalar(NULL, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(.check_scalar(NULL, allow_null = FALSE), error = TRUE)
  expect_error(
    .check_scalar(character(), allow_zero_length = FALSE),
    class = .compile_dash("stbl", "error", "bad_empty")
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

test_that(".check_x_no_more_than_y() works", {
  expect_null(.check_x_no_more_than_y(1, 2))
  expect_null(.check_x_no_more_than_y(2, 2))
  expect_null(.check_x_no_more_than_y(NULL, 2))
  expect_null(.check_x_no_more_than_y(1, NULL))
  expect_error(
    .check_x_no_more_than_y(2, 1),
    class = .compile_dash("stbl", "error", "size_x_vs_y")
  )
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
  expect_error(
    .check_cast_failures(
      failures = failures,
      x_class = "character",
      to = logical(),
      due_to = "incompatible values",
      x_arg = "test_arg",
      call = rlang::current_env()
    ),
    class = .compile_dash("stbl", "error", "incompatible_type")
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
