test_that("to_int() works for ints (#2, #6)", {
  given <- 1:10
  expect_identical(to_int(given), given)
})

test_that("to_int() works for NULL (#2)", {
  given <- NULL
  expect_identical(to_int(given), given)
})

test_that("to_int() respects allow_null (#2)", {
  given <- NULL
  expect_error(
    to_int(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_int(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_int(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_int() works for lgls (#2)", {
  given <- c(TRUE, FALSE)
  expected <- as.integer(given)
  expect_identical(to_int(given), expected)
})

test_that("to_int() works for dbls (#2)", {
  expected <- 1:10
  given <- as.double(expected)
  expect_identical(to_int(given), expected)
})

test_that("to_int() errors for dbls that would lose precision (#2)", {
  # These errors are from vctrs, so just watch for that error class
  given <- as.double(1:10)
  given[[4]] <- 1.1
  expect_error(
    to_int(given),
    class = "vctrs_error_cast_lossy"
  )
  given[[4]] <- Inf
  expect_error(
    to_int(given),
    class = "vctrs_error_cast_lossy"
  )
})

test_that("to_int() works for chrs (#2)", {
  expected <- 1:10
  given <- as.character(expected)
  expect_identical(to_int(given), expected)
})

test_that("to_int() respects coerce_character (#14)", {
  expected <- 1:10
  given <- as.character(expected)
  expect_error(
    to_int(given, coerce_character = FALSE),
    class = .compile_dash("stbl", "error", "coerce", "integer")
  )
  expect_snapshot(
    to_int(given, coerce_character = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_int(given, coerce_character = FALSE),
    error = TRUE
  )
})

test_that("to_int() errors informatively for bad chrs (#2)", {
  given <- as.character(1:10)
  given[[4]] <- "1.1"
  expect_error(
    to_int(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    to_int(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_int(given),
    error = TRUE
  )

  given[[4]] <- "a"
  expect_error(
    to_int(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    to_int(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_int(given),
    error = TRUE
  )
})

test_that("to_int() works for complexes (#2)", {
  expected <- 1:10
  given <- as.complex(expected)
  expect_identical(to_int(given), expected)
})

test_that("to_int() errors informatively for bad complexes (#2)", {
  given <- as.complex(1:10)
  given[[4]] <- 1 + 1i
  expect_error(
    to_int(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    to_int(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_int(given),
    error = TRUE
  )
})

test_that("to_int() works for factors (#4)", {
  expected <- c(1L, 3L, 5L, 7L)
  given <- factor(expected)
  expect_identical(to_int(given), expected)
})

test_that("to_int() respects coerce_factor (#14)", {
  expected <- c(1L, 3L, 5L, 7L)
  given <- factor(expected)
  expect_error(
    to_int(given, coerce_factor = FALSE),
    class = .compile_dash("stbl", "error", "coerce", "integer")
  )
  expect_snapshot(
    to_int(given, coerce_factor = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_int(given, coerce_factor = FALSE),
    error = TRUE
  )
})

test_that("to_int() errors informatively for bad factors (#4)", {
  given <- factor(letters)
  expect_error(
    to_int(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    to_int(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_int(given),
    error = TRUE
  )
})

test_that("to_int() works for lists (#2)", {
  expect_identical(to_int(list(1L, 2.0, "3")), c(1L, 2L, 3L))
  expect_identical(to_int(list(list(1L), 2L)), c(1L, 2L))
  expect_error(
    to_int(list(1L, 1:5)),
    class = .compile_dash("stbl", "error", "coerce", "integer")
  )
})

test_that("to_int() errors properly for other types (#2)", {
  # These errors are from vctrs, so just watch for that error class
  given <- as.raw(1:10)
  expect_error(to_int(given), class = "vctrs_error_cast")
  expect_error(to_int(mean), class = "vctrs_error_scalar_type")
})

test_that("to_int_scalar() allows length-1 ints through (#12)", {
  given <- 1L
  expect_identical(to_int_scalar(given), given)
})

test_that("to_int_scalar() provides informative error messages (#12)", {
  given <- 1:10
  expect_error(
    to_int_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    to_int_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_int_scalar(given),
    error = TRUE
  )
})

test_that("to_integer() exists (#164)", {
  expect_no_error(to_integer(1))
})

test_that("to_integer_scalar() exists (#164)", {
  expect_no_error(to_integer_scalar(1))
})
