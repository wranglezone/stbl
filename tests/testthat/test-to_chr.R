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

test_that("to_chr() converts named functions (#251)", {
  expect_identical(to_chr(mean), "base::mean")
  expect_identical(to_chr(abs), "base::abs") # primitive
  expect_identical(to_chr(base::mean), "base::mean") # qualified call

  # User-defined function: returns its name
  my_fn <- function(x) x + 1
  expect_identical(to_chr(my_fn), "my_fn")

  # Aliased: function held under a name not in its namespace, returns the name
  given <- mean
  expect_identical(to_chr(given), "given")

  # Aliased: name exists in namespace but body differs
  local({
    abs <- mean
    expect_identical(to_chr(abs), "abs")
  })

  # Works through the full chr family
  expect_identical(to_chr_scalar(mean), "base::mean")
  expect_identical(stabilize_chr(mean), "base::mean")
  expect_identical(stabilize_chr_scalar(mean), "base::mean")

  # Without {{ }}, the wrapper's parameter name is returned
  expect_identical(wrapped_to_chr(mean), "val")

  # With {{ }}, the original call-site symbol is preserved
  wrapper_embrace <- function(fn) to_chr({{ fn }})
  expect_identical(wrapper_embrace(mean), "base::mean")
  expect_identical(wrapper_embrace(abs), "base::abs")
})

test_that("to_chr() errors for anonymous functions (#251)", {
  expect_error(
    to_chr(function(x) x),
    class = .compile_dash("stbl", "error", "coerce", "character")
  )
  expect_snapshot(to_chr(function(x) x), error = TRUE)

  # Without {{ }}, the wrapper's parameter name is used, so no error
  expect_identical(wrapped_to_chr(function(x) x), "val")
})

test_that("to_chr() fails gracefully for weird cases (#22)", {
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

test_that("to_chr_scalar() allows length-1 chrs through (#22, #189)", {
  expect_identical(
    to_chr_scalar("a"),
    "a"
  )
  expect_null(to_chr_scalar(NULL, allow_null = TRUE))
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

test_that("to_chr_scalar() respects allow_null (#22, #189)", {
  given <- NULL
  expect_error(
    to_chr_scalar(given),
    class = .compile_dash("stbl", "error", "bad_null")
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

test_that("to_chr_scalar respects allow_zero_length (#22, #43, #45, #189)", {
  given <- character()
  expect_error(
    to_chr_scalar(given),
    class = .compile_dash("stbl", "error", "bad_empty")
  )
  expect_snapshot(
    to_chr_scalar(given),
    error = TRUE
  )
})

test_that("to_character() exists (#164)", {
  expect_no_error(to_character(TRUE))
})

test_that("to_character_scalar() exists (#164)", {
  expect_no_error(to_character_scalar(TRUE))
})

test_that("to_chr() works for ints via C (#241)", {
  expect_identical(to_chr(1L), "1")
  expect_identical(to_chr(1:5), as.character(1:5))
  expect_identical(to_chr(NA_integer_), NA_character_)
})

test_that("to_chr() works for lgls via C (#241)", {
  expect_identical(to_chr(TRUE), "TRUE")
  expect_identical(to_chr(FALSE), "FALSE")
  expect_identical(to_chr(NA), NA_character_)
  expect_identical(
    to_chr(c(TRUE, FALSE, NA)),
    c("TRUE", "FALSE", NA_character_)
  )
})

test_that("to_chr() works for dbls via C (#241)", {
  expect_identical(to_chr(1.5), "1.5")
  expect_identical(to_chr(NA_real_), NA_character_)
  expect_identical(to_chr(Inf), "Inf")
  expect_identical(to_chr(-Inf), "-Inf")
  expect_identical(to_chr(NaN), "NaN")
})

test_that("to_chr() works for fcts via C (#241)", {
  given <- factor(c("a", "b", NA, "a"))
  expect_identical(to_chr(given), c("a", "b", NA_character_, "a"))

  given <- factor(c("x", "y"), levels = c("x", "y", "z"))
  expect_identical(to_chr(given), c("x", "y"))
})

test_that("to_chr() falls back to as.character() for other types (#noissue)", {
  # complex
  expect_identical(to_chr(1 + 2i), "1+2i")
  expect_identical(to_chr(1 + 0i), "1+0i")

  # Date — ISO 8601 format
  expect_identical(to_chr(as.Date("2026-01-15")), "2026-01-15")

  # POSIXct — format is timezone-dependent, just verify the type
  expect_type(
    to_chr(as.POSIXct("2026-01-15 12:00:00", tz = "UTC")),
    "character"
  )

  # raw — lowercase hex
  expect_identical(to_chr(as.raw(c(0x0a, 0xff))), c("0a", "ff"))

  # condition — as.character() returns the formatted message with class prefix
  # and trailing newline, not just conditionMessage() (see #258)
  expect_identical(to_chr(simpleError("oops")), "Error: oops\n")

  # formula — splits into a 3-element vector: operator, LHS, RHS (see #259)
  expect_identical(to_chr(y ~ x), c("~", "y", "x"))
})
