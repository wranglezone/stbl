test_that("stabilize_fct() works", {
  expect_identical(stabilize_fct(letters), factor(letters))
})

test_that("stabilize_fct() throws errors for bad levels", {
  expect_error(
    stabilize_fct(letters[1:5], levels = c("a", "c"), to_na = "b"),
    class = .compile_dash("stbl", "error", "fct_levels")
  )
  expect_snapshot(
    stabilize_fct(letters[1:5], levels = c("a", "c"), to_na = "b"),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_fct(letters[1:5], levels = c("a", "c"), to_na = "b"),
    error = TRUE
  )
})

test_that("stabilize_fct_scalar() works", {
  expect_identical(stabilize_fct_scalar("a"), factor("a"))
})

test_that("stabilize_fct_scalar() errors for non-scalars", {
  given <- letters
  expect_error(
    stabilize_fct_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    stabilize_fct_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_stabilize_fct_scalar(given),
    error = TRUE
  )
})
