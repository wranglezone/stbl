test_that("stabilize_fct() works (#62)", {
  expect_identical(stabilize_fct(letters), factor(letters))
})

test_that("stabilize_fct() throws errors for bad levels (#62)", {
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

test_that("stabilize_fct_scalar() works (#62)", {
  expect_identical(stabilize_fct_scalar("a"), factor("a"))
})

test_that("stabilize_fct_scalar() errors for non-scalars (#62)", {
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

test_that("stabilize_factor() exists (#164)", {
  expect_no_error(stabilize_factor(TRUE))
})

test_that("stabilize_factor_scalar() exists (#164)", {
  expect_no_error(stabilize_factor_scalar(TRUE))
})
