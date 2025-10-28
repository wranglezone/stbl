test_that("to_dbl() works for dbls (#23)", {
  given <- c(1.1, 2.2)
  expect_identical(to_dbl(given), given)
})

test_that("to_dbl() works for ints (#23)", {
  given <- 1:10
  expect_identical(to_dbl(given), as.double(given))
})

test_that("to_dbl() works for NULL (#23)", {
  given <- NULL
  expect_identical(to_dbl(given), given)
})

test_that("to_dbl() respects allow_null (#23)", {
  given <- NULL
  expect_error(
    to_dbl(given, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_dbl(given, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_dbl(given, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_dbl() works for lgls (#23)", {
  given <- c(TRUE, FALSE)
  expected <- as.double(given)
  expect_identical(to_dbl(given), expected)
})

test_that("to_dbl() works for chrs (#23)", {
  expected <- c(1.1, 2.2)
  given <- as.character(expected)
  expect_identical(to_dbl(given), expected)
})

test_that("to_dbl() respects coerce_character (#23)", {
  expected <- c(1.1, 2.2)
  given <- as.character(expected)
  expect_error(
    to_dbl(given, coerce_character = FALSE),
    class = .compile_dash("stbl", "error", "coerce", "double")
  )
  expect_snapshot(
    to_dbl(given, coerce_character = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_dbl(given, coerce_character = FALSE),
    error = TRUE
  )
})

test_that("to_dbl() errors informatively for bad chrs (#23)", {
  given <- c("1.1", "a")
  expect_error(
    to_dbl(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    to_dbl(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_dbl(given),
    error = TRUE
  )
})

test_that("to_dbl() works for complexes (#23)", {
  expected <- c(1.1, 2.2)
  given <- as.complex(expected)
  expect_identical(to_dbl(given), expected)
})

test_that("to_dbl() errors informatively for bad complexes (#23)", {
  given <- as.complex(c(1.1, 2.2))
  given[[1]] <- 1.1 + 1i
  expect_error(
    to_dbl(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    to_dbl(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_dbl(given),
    error = TRUE
  )
})

test_that("to_dbl() works for factors (#23)", {
  expected <- c(1.1, 3.3)
  given <- factor(expected)
  expect_identical(to_dbl(given), expected)
})

test_that("to_dbl() respects coerce_factor (#23)", {
  expected <- c(1.1, 3.3)
  given <- factor(expected)
  expect_error(
    to_dbl(given, coerce_factor = FALSE),
    class = .compile_dash("stbl", "error", "coerce", "double")
  )
  expect_snapshot(
    to_dbl(given, coerce_factor = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_dbl(given, coerce_factor = FALSE),
    error = TRUE
  )
})

test_that("to_dbl() errors informatively for bad factors (#23)", {
  given <- factor(letters)
  expect_error(
    to_dbl(given),
    class = .compile_dash("stbl", "error", "incompatible_type")
  )
  expect_snapshot(
    to_dbl(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_dbl(given),
    error = TRUE
  )
})

test_that("to_dbl() works for lists (#128)", {
  expect_identical(to_dbl(list(1.1, 2L, "3.3")), c(1.1, 2.0, 3.3))
  expect_identical(to_dbl(list(list(1.1), 2L)), c(1.1, 2.0))
  expect_error(
    to_dbl(list(1.1, 1:5)),
    class = .compile_dash("stbl", "error", "coerce", "double")
  )
})

test_that("to_dbl() errors properly for other types (#23)", {
  given <- as.raw(1:10)
  expect_error(to_dbl(given), class = "vctrs_error_cast")
  expect_error(to_dbl(mean), class = "vctrs_error_scalar_type")
})

test_that("to_dbl_scalar() allows length-1 dbls through (#23)", {
  given <- 1.1
  expect_identical(to_dbl_scalar(given), given)
})

test_that("to_dbl_scalar() provides informative error messages (#23)", {
  given <- c(1.1, 2.2)
  expect_error(
    to_dbl_scalar(given),
    class = .compile_dash("stbl", "error", "non_scalar")
  )
  expect_snapshot(
    to_dbl_scalar(given),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_dbl_scalar(given),
    error = TRUE
  )
})
