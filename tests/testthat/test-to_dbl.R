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
  expect_pkg_error_snapshot(
    to_dbl(given, allow_null = FALSE),
    "stbl",
    "bad_null"
  )
  expect_pkg_error_snapshot(
    wrapped_to_dbl(given, allow_null = FALSE),
    "stbl",
    "bad_null"
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
  expect_pkg_error_snapshot(
    to_dbl(given, coerce_character = FALSE),
    "stbl",
    "coerce",
    "double"
  )
  expect_pkg_error_snapshot(
    wrapped_to_dbl(given, coerce_character = FALSE),
    "stbl",
    "coerce",
    "double"
  )
})

test_that("to_dbl() errors informatively for bad chrs (#23, #310, #335)", {
  given <- c("1.1", "a")
  expect_pkg_error_snapshot(
    to_dbl(given),
    "stbl",
    "incompatible_values",
    "double"
  )
  expect_pkg_error_snapshot(
    wrapped_to_dbl(given),
    "stbl",
    "incompatible_values",
    "double"
  )
})

test_that("to_dbl() works for complexes (#23)", {
  expected <- c(1.1, 2.2)
  given <- as.complex(expected)
  expect_identical(to_dbl(given), expected)
})

test_that("to_dbl() errors informatively for bad complexes (#23, #310)", {
  given <- as.complex(c(1.1, 2.2))
  given[[1]] <- 1.1 + 1i
  expect_pkg_error_snapshot(
    to_dbl(given),
    "stbl",
    "incompatible_values",
    "double"
  )
  expect_pkg_error_snapshot(
    wrapped_to_dbl(given),
    "stbl",
    "incompatible_values",
    "double"
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
  expect_pkg_error_snapshot(
    to_dbl(given, coerce_factor = FALSE),
    "stbl",
    "coerce",
    "double"
  )
  expect_pkg_error_snapshot(
    wrapped_to_dbl(given, coerce_factor = FALSE),
    "stbl",
    "coerce",
    "double"
  )
})

test_that("to_dbl() errors informatively for bad factors (#23, #310, #335)", {
  given <- factor(letters)
  expect_pkg_error_snapshot(
    to_dbl(given),
    "stbl",
    "incompatible_values",
    "double"
  )
  expect_pkg_error_snapshot(
    wrapped_to_dbl(given),
    "stbl",
    "incompatible_values",
    "double"
  )
})

test_that("to_dbl() works for lists (#128, #273, #310)", {
  expect_identical(to_dbl(list(1.1, 2L, "3.3")), c(1.1, 2.0, 3.3))
  expect_identical(to_dbl(list(list(1.1), 2L)), c(1.1, 2.0))
  expect_pkg_error_snapshot(
    to_dbl(list(1.1, 1:5)),
    "stbl",
    "incompatible_values",
    "double"
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
  expect_pkg_error_snapshot(to_dbl_scalar(given), "stbl", "non_scalar")
  expect_pkg_error_snapshot(wrapped_to_dbl_scalar(given), "stbl", "non_scalar")
})

test_that("to_dbl_scalar() respects allow_null (#23, #189)", {
  given <- NULL
  expect_pkg_error_snapshot(to_dbl_scalar(given), "stbl", "bad_null")
  expect_pkg_error_snapshot(wrapped_to_dbl_scalar(given), "stbl", "bad_null")
})

test_that("to_dbl_scalar respects allow_zero_length (#23, #43, #45, #189)", {
  given <- double()
  expect_pkg_error_snapshot(to_dbl_scalar(given), "stbl", "bad_empty")
})

test_that("to_double() exists (#164)", {
  expect_no_error(to_double(1))
})

test_that("to_double_scalar() exists (#164)", {
  expect_no_error(to_double_scalar(1))
})
