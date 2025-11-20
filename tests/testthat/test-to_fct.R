test_that("to_fct() works for fcts (#62)", {
  given <- factor(letters)
  expect_identical(to_fct(given), given)

  given[[4]] <- NA
  expect_identical(to_fct(given), given)
})

test_that("to_fct() deals with levels of fcts (#62)", {
  given <- factor(c("a", "b"))
  expected <- factor(c("a", NA))
  expect_identical(to_fct(given, levels = "a", to_na = "b"), expected)
})

test_that("to_fct() throws errors for bad levels (#62, #177)", {
  expect_error(
    to_fct(letters[1:5], levels = c("a", "c"), to_na = "b"),
    class = .compile_dash("stbl", "error", "fct_levels")
  )
  expect_snapshot(
    to_fct(letters[1:5], levels = c("a", "c"), to_na = "b"),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_fct(letters[1:5], levels = c("a", "c"), to_na = "b"),
    error = TRUE
  )
})

test_that("to_fct() works for chrs (#62)", {
  given <- letters
  expected <- factor(letters)
  expect_identical(to_fct(given), expected)

  given[[4]] <- NA
  expected <- factor(given)
  expect_identical(to_fct(given), expected)
})

test_that("to_fct() works for NULL (#62)", {
  given <- NULL
  expect_identical(to_fct(given), given)
})

test_that("to_fct() respects allow_null (#62)", {
  given <- NULL
  expect_error(
    to_fct(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_fct(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_fct(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_fct() works for lists (#64)", {
  expect_identical(
    to_fct(list("a", "b")),
    factor(c("a", "b"))
  )
  expect_identical(
    to_fct(list(list("a"), "b")),
    factor(c("a", "b"))
  )
  expect_error(
    to_fct(list("a", 1:5)),
    class = .compile_dash("stbl", "error", "coerce", "factor")
  )
})

test_that("to_fct() errors for things that can't be coerced (#62)", {
  given <- mean
  expect_error(
    to_fct(given),
    class = .compile_dash("stbl", "error", "coerce", "factor")
  )
  expect_snapshot(to_fct(given), error = TRUE)
  expect_snapshot(wrapped_to_fct(given), error = TRUE)

  given <- mtcars
  expect_error(
    to_fct(given),
    class = .compile_dash("stbl", "error", "coerce", "factor")
  )
  expect_snapshot(to_fct(given), error = TRUE)
  expect_snapshot(wrapped_to_fct(given), error = TRUE)

  given <- list(a = 1, b = 1:5)
  expect_error(
    to_fct(given),
    class = .compile_dash("stbl", "error", "coerce", "factor")
  )
  expect_snapshot(to_fct(given), error = TRUE)
  expect_snapshot(wrapped_to_fct(given), error = TRUE)
})

test_that("to_fct() treats numbers as text (#62)", {
  given <- 1:10
  expect_identical(to_fct(given), factor(given))
})

test_that("to_fct_scalar() allows length-1 fcts through (#62)", {
  expect_identical(to_fct_scalar("a"), factor("a"))
  expect_identical(to_fct_scalar("a", levels = "a"), factor("a"))
})

test_that("to_fct_scalar() provides informative error messages (#62)", {
  given <- letters
  expect_error(
    to_fct_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(to_fct_scalar(given), error = TRUE)
  expect_snapshot(wrapped_to_fct_scalar(given), error = TRUE)
})

test_that("to_fct_scalar respects allow_zero_length (#62)", {
  given <- factor()
  expect_error(
    to_fct_scalar(given, allow_zero_length = FALSE),
    class = .compile_dash("stbl", "error", "bad_empty")
  )
  expect_snapshot(
    to_fct_scalar(given, allow_zero_length = FALSE),
    error = TRUE
  )
})

test_that("to_factor() exists (#164)", {
  expect_no_error(to_factor("a"))
})

test_that("to_factor_scalar() exists (#164)", {
  expect_no_error(to_factor_scalar("a"))
})
