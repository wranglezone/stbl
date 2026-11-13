expect_dot_errors <- function(fn, ...) {
  expect_error(fn(..., typo_arg = TRUE), class = "rlib_error_dots_nonempty")
  expect_error(fn(..., TRUE), class = "rlib_error_dots_nonempty")
}
