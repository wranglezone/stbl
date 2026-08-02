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

test_that("to_fct() throws errors for bad levels (#62, #67, #177)", {
  expect_pkg_error_snapshot(
    to_fct(letters[1:5], levels = c("a", "c"), to_na = "b"),
    "stbl",
    "fct_levels"
  )
  expect_pkg_error_snapshot(
    wrapped_to_fct(letters[1:5], levels = c("a", "c"), to_na = "b"),
    "stbl",
    "fct_levels"
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
  expect_pkg_error_snapshot(
    to_fct(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_to_fct(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
})

test_that("to_fct() works for lists (#64, #273, wranglezone/stbl#310)", {
  expect_identical(
    to_fct(list("a", "b")),
    factor(c("a", "b"))
  )
  expect_identical(
    to_fct(list(list("a"), "b")),
    factor(c("a", "b"))
  )
  expect_pkg_error_snapshot(
    to_fct(list("a", 1:5)),
    "stbl",
    "incompatible_values", "factor"
  )
})

test_that("to_fct() errors for things that can't be coerced (#62, #273, wranglezone/stbl#310)", {
  given <- mean
  expect_pkg_error_snapshot(to_fct(given), "stbl", "coerce", "factor")
  expect_pkg_error_snapshot(wrapped_to_fct(given), "stbl", "coerce", "factor")

  given <- mtcars
  expect_pkg_error_snapshot(to_fct(given), "stbl", "coerce", "factor")
  expect_pkg_error_snapshot(wrapped_to_fct(given), "stbl", "coerce", "factor")

  given <- list(a = 1, b = 1:5)
  expect_pkg_error_snapshot(
    to_fct(given),
    "stbl",
    "incompatible_values", "factor"
  )
  expect_pkg_error_snapshot(
    wrapped_to_fct(given),
    "stbl",
    "incompatible_values", "factor"
  )
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
  expect_pkg_error_snapshot(to_fct_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(wrapped_to_fct_scalar(given), "stbl", "non_scalar")
})

test_that("to_fct_scalar respects allow_zero_length (#62, #43, #45, #189)", {
  given <- factor()
  expect_pkg_error_snapshot(to_fct_scalar(given), "stbl", "bad_empty")
})

test_that("to_factor() exists (#164)", {
  expect_no_error(to_factor("a"))
})

test_that("to_factor_scalar() exists (#164)", {
  expect_no_error(to_factor_scalar("a"))
})

test_that("to_fct() works for ints via C (#241)", {
  given <- c(1L, 2L, 1L)
  expected <- factor(c("1", "2", "1"))
  expect_identical(to_fct(given), expected)

  given[[2]] <- NA_integer_
  expected <- factor(c("1", NA, "1"))
  expect_identical(to_fct(given), expected)
})

test_that("to_fct() errors for ints with unexpected levels (#241)", {
  given <- c(1L, 2L, 3L)
  expect_pkg_error_snapshot(
    to_fct(given, levels = c("1", "2")),
    "stbl",
    "fct_levels"
  )
  expect_pkg_error_snapshot(
    wrapped_to_fct(given, levels = c("1", "2")),
    "stbl",
    "fct_levels"
  )
})

test_that("to_fct() works for logical vectors via default dispatch (#noissue)", {
  given <- c(TRUE, FALSE, TRUE)
  expect_identical(to_fct(given), factor(given))
})

test_that("to_fct() sorts integer levels numerically not lexicographically (#241)", {
  given <- c(1L, 10L, 2L)
  result <- to_fct(given)
  expect_identical(levels(result), c("1", "2", "10"))
})

test_that("to_fct() attaches bad-level locations (#274)", {
  cnd <- rlang::catch_cnd(to_fct(c("a", "b", "c", "d"), levels = c("a", "b")))
  expect_identical(cnd$locations, c(3L, 4L))
})
