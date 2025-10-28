test_that("to_chr() works for chrs (#22)", {
  expect_identical(to_chr("a"), "a")

  given <- letters
  expect_identical(
    to_chr(given),
    given
  )

  given[[4]] <- NA
  expect_identical(
    to_chr(given),
    given
  )
})

test_that("to_chr() works for NULL (#22)", {
  given <- NULL
  expect_identical(
    to_chr(given),
    given
  )
})

test_that("to_chr() respects allow_null (#22)", {
  given <- NULL
  expect_error(
    to_chr(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_chr(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_chr(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_chr() works for other things (#22)", {
  given <- 1:10
  expect_identical(
    to_chr(given),
    as.character(given)
  )
  given <- given + 0.1
  expect_identical(
    to_chr(given),
    as.character(given)
  )
  given <- c(TRUE, FALSE, TRUE)
  expect_identical(
    to_chr(given),
    as.character(given)
  )
})

test_that("to_chr() tries to flatten lists (#22)", {
  expect_identical(
    to_chr(list("a", "b")),
    c("a", "b")
  )
  expect_identical(
    to_chr(list(1, 2)),
    c("1", "2")
  )
  expect_identical(
    to_chr(list("a")),
    "a"
  )
  expect_identical(
    to_chr(list(list("a"))),
    "a"
  )
  expect_identical(
    to_chr(list(list("a"), "b")),
    c("a", "b")
  )
})

test_that("to_chr() fails gracefully for weird cases (#22)", {
  given <- mean
  expect_error(
    to_chr(given),
    class = .compile_dash("stbl", "error", "coerce", "character")
  )
  expect_snapshot(
    to_chr(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_chr(given),
    error = TRUE
  )

  given <- list(mean)
  expect_error(
    to_chr(given),
    class = .compile_dash("stbl", "error", "coerce", "character")
  )
  expect_snapshot(
    to_chr(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_chr(given),
    error = TRUE
  )

  given <- list("x", mean)
  expect_error(
    to_chr(given),
    class = .compile_dash("stbl", "error", "coerce", "character")
  )
  expect_snapshot(
    to_chr(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_chr(given),
    error = TRUE
  )

  given <- mtcars
  expect_error(
    to_chr(given),
    class = .compile_dash("stbl", "error", "coerce", "character")
  )
  expect_snapshot(
    to_chr(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_chr(given),
    error = TRUE
  )

  given <- list(a = 1, b = 1:5)
  expect_error(
    to_chr(given),
    class = .compile_dash("stbl", "error", "coerce", "character")
  )
  expect_snapshot(
    to_chr(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_chr(given),
    error = TRUE
  )
})

test_that("to_chr_scalar() allows length-1 chrs through (#22)", {
  expect_identical(
    to_chr_scalar("a"),
    "a"
  )
  expect_null(to_chr_scalar(NULL))
})

test_that("to_chr_scalar() errors for non-scalars (#22)", {
  given <- letters
  expect_error(
    to_chr_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    to_chr_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_chr_scalar(given),
    error = TRUE
  )
})

test_that("to_chr_scalar() errors for uncoerceable types (#22)", {
  given <- list(a = 1:10)
  expect_error(
    to_chr_scalar(given),
    class = .compile_dash("stbl", "error", "coerce", "character")
  )
  expect_snapshot(
    to_chr_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_chr_scalar(given),
    error = TRUE
  )
})

test_that("to_chr_scalar() respects allow_null (#22)", {
  given <- NULL
  expect_error(
    to_chr_scalar(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_chr_scalar(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_chr_scalar(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_chr_scalar respects allow_zero_length (#22)", {
  given <- character()
  expect_error(
    to_chr_scalar(given, allow_zero_length = FALSE),
    class = .compile_dash("stbl", "error", "bad_empty")
  )
  expect_snapshot(
    to_chr_scalar(given, allow_zero_length = FALSE),
    error = TRUE
  )
})
