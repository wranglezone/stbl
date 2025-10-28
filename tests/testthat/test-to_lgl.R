test_that("to_lgl() works for lgls (#21)", {
  expect_true(to_lgl(TRUE))
  expect_false(to_lgl(FALSE))

  given <- sample(c(TRUE, FALSE), size = 10, replace = TRUE)
  expect_identical(
    to_lgl(given),
    given
  )

  given[[4]] <- NA
  expect_identical(
    to_lgl(given),
    given
  )
})

test_that("to_lgl() works for NULL (#21)", {
  given <- NULL
  expect_identical(
    to_lgl(given),
    given
  )
})

test_that("to_lgl() respects allow_null (#21)", {
  given <- NULL
  expect_error(
    to_lgl(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_lgl(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lgl(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_lgl() works for integers (#21)", {
  given <- 1L
  expect_true(to_lgl(given))
  given <- 0L
  expect_false(to_lgl(given))

  # By default, behave the same as as.logical for ints. I don't have the
  # specific use case for anything else yet, so leave this!
  given <- 1:10
  expect_identical(
    to_lgl(given),
    as.logical(given)
  )
})

test_that("to_lgl() works for doubles (#21)", {
  given <- 1
  expect_true(to_lgl(given))
  given <- 0
  expect_false(to_lgl(given))

  # By default, behave the same as as.logical for dbls. I don't have the
  # specific use case for anything else yet, so leave this!
  given <- c(1, 2, 3.1, 4.4, 5)
  expect_identical(
    to_lgl(given),
    as.logical(given)
  )
})

test_that("to_lgl works for characters (#21)", {
  given <- "TRUE"
  expect_true(to_lgl(given))
  given <- "FALSE"
  expect_false(to_lgl(given))

  given <- c(
    "TRUE",
    "T",
    "true",
    "FALSE",
    "F",
    "false"
  )
  expect_identical(
    to_lgl(given),
    as.logical(given)
  )
  given <- c(
    "TRUE",
    "T",
    "true",
    "t",
    "TrUe",
    "FALSE",
    "F",
    "false",
    "f",
    "fAlSe"
  )
  expect_identical(
    to_lgl(given),
    c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE)
  )

  expect_identical(to_lgl(c("0", "1", "-1", "10")), c(FALSE, TRUE, TRUE, TRUE))
  expect_identical(to_lgl(c("1.0", "0.0")), c(TRUE, FALSE))
  expect_identical(to_lgl(c("1.1", "0.1", "-1.1")), c(TRUE, TRUE, TRUE))
})

test_that("to_lgl() errors for bad characters (#21)", {
  expect_error(
    to_lgl(letters),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    to_lgl(letters),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lgl(letters),
    error = TRUE
  )
})

test_that("to_lgl works for factors (#21)", {
  given <- factor("TRUE")
  expect_true(to_lgl(given))
  given <- factor("FALSE")
  expect_false(to_lgl(given))

  given <- factor(c(
    "TRUE",
    "T",
    "true",
    "FALSE",
    "F",
    "false"
  ))
  expect_identical(
    to_lgl(given),
    as.logical(given)
  )
  given <- factor(c(
    "TRUE",
    "T",
    "true",
    "t",
    "TrUe",
    "FALSE",
    "F",
    "false",
    "f",
    "fAlSe"
  ))
  expect_identical(
    to_lgl(given),
    c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE)
  )
})

test_that("to_lgl errors for bad factors (#21)", {
  given <- factor(letters)
  expect_error(
    to_lgl(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    to_lgl(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lgl(given),
    error = TRUE
  )
})

test_that("to_lgl() works for lists (#21)", {
  expect_identical(
    to_lgl(list(TRUE, FALSE, 1, 0, "T", "F")),
    as.logical(c(1, 0, 1, 0, 1, 0))
  )
  expect_identical(to_lgl(list(list(TRUE), 0L)), c(TRUE, FALSE))
  expect_error(
    to_lgl(list(TRUE, 1:5)),
    class = .compile_dash("stbl", "error", "coerce", "logical")
  )
})

test_that("to_lgl() errors for other types (#21)", {
  given <- list(1, 1:10)
  expect_error(
    to_lgl(given),
    class = .compile_dash("stbl", "error", "coerce", "logical")
  )
  expect_snapshot(
    to_lgl(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lgl(given),
    error = TRUE
  )

  given <- mean
  expect_error(
    to_lgl(given),
    class = .compile_dash("stbl", "error", "coerce", "logical")
  )
  expect_snapshot(
    to_lgl(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lgl(given),
    error = TRUE
  )
})

test_that("to_lgl_scalar() allows length-1 lgls through (#32)", {
  given <- TRUE
  expect_true(to_lgl_scalar(given))
  given <- FALSE
  expect_false(to_lgl_scalar(given))
  given <- NULL
  expect_null(to_lgl_scalar(given))
})

test_that("to_lgl_scalar() errors for non-scalars (#32)", {
  given <- c(TRUE, FALSE, TRUE)
  expect_error(
    to_lgl_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    to_lgl_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lgl_scalar(given),
    error = TRUE
  )
})

test_that("to_lgl_scalar() errors for bad characters (#32)", {
  given <- "a"
  expect_error(
    to_lgl_scalar(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    to_lgl_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lgl_scalar(given),
    error = TRUE
  )
})

test_that("to_lgl_scalar() respects allow_null (#32)", {
  given <- NULL
  expect_error(
    to_lgl_scalar(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_lgl_scalar(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_lgl_scalar(given, allow_null = FALSE),
    error = TRUE
  )
})
