test_that("to_df() returns a data frame unchanged (#201)", {
  expect_identical(to_df(mtcars), mtcars)
})

test_that("to_df() returns NULL for NULL input by default (#201)", {
  expect_null(to_df(NULL))
})

test_that("to_df() respects allow_null (#201)", {
  expect_error(
    to_df(NULL, allow_null = FALSE),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    to_df(NULL, allow_null = FALSE),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_df(NULL, allow_null = FALSE),
    error = TRUE
  )
})

test_that("to_df() coerces a named list to a data frame (#201)", {
  given <- list(name = "Alice", age = 30L)
  result <- to_df(given)
  expect_s3_class(result, "data.frame")
  expect_identical(result$name, "Alice")
  expect_identical(result$age, 30L)
})

test_that("to_df() coerces a list of equal-length vectors to a data frame (#201)", {
  given <- list(x = 1:3, y = letters[1:3])
  result <- to_df(given)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3L)
  expect_identical(result$x, 1:3)
  expect_identical(result$y, letters[1:3])
})

test_that("to_df() errors for a list with incompatible column lengths (#201)", {
  expect_error(
    to_df(list(a = 1:3, b = 1:2)),
    class = .compile_dash("stbl", "error", "jagged")
  )
  expect_snapshot(
    to_df(list(a = 1:3, b = 1:2)),
    error = TRUE
  )
  expect_snapshot(
    wrapped_to_df(list(a = 1:3, b = 1:2)),
    error = TRUE
  )
})

test_that("to_df() errors for an unnamed list (#203)", {
  expect_error(
    to_df(list(1, 2)),
    class = .compile_dash("stbl", "error", "bad_named")
  )
  expect_snapshot(
    to_df(list(1, 2)),
    error = TRUE
  )
})

test_that("to_df() errors for non-coercible types (#201)", {
  expect_error(
    to_df("not a data frame"),
    class = .compile_dash("stbl", "error", "coerce", "data.frame")
  )
  expect_snapshot(
    to_df("not a data frame"),
    error = TRUE
  )
})

test_that("to_df() coerces named vector types to a data frame (#203)", {
  expect_identical(to_df(letters), data.frame(letters = letters))

  my_int <- 1:5
  expect_identical(to_df(my_int), data.frame(my_int = my_int))

  my_dbl <- c(1.5, 2.5)
  expect_identical(to_df(my_dbl), data.frame(my_dbl = my_dbl))

  my_lgl <- c(TRUE, FALSE)
  expect_identical(to_df(my_lgl), data.frame(my_lgl = my_lgl))

  my_cplx <- complex(real = 1:2, imaginary = 3:4)
  expect_identical(to_df(my_cplx), data.frame(my_cplx = my_cplx))

  my_raw <- as.raw(c(1L, 2L))
  expect_identical(to_df(my_raw), data.frame(my_raw = my_raw))

  my_fct <- factor(c("a", "b"))
  expect_identical(to_df(my_fct), data.frame(my_fct = my_fct))
})

test_that("to_df() errors for inline vector expressions (#203)", {
  expect_error(
    to_df(c("a", "b", "c")),
    class = .compile_dash("stbl", "error", "coerce", "data.frame")
  )
  expect_error(
    to_df(c(1.5, 2.5)),
    class = .compile_dash("stbl", "error", "coerce", "data.frame")
  )
})

test_that("to_df.default() errors for non-coercible types (#201)", {
  expect_error(
    to_df(as.Date("2024-01-01")),
    class = .compile_dash("stbl", "error", "coerce", "data.frame")
  )
  expect_snapshot(
    to_df(as.Date("2024-01-01")),
    error = TRUE
  )
})

test_that("to_data_frame() exists (#201)", {
  expect_identical(to_data_frame(mtcars), mtcars)
})
