test_that("stabilize_present() returns any non-NULL value unchanged (#110)", {
  expect_identical(stabilize_present("hello"), "hello")
  expect_identical(stabilize_present(1L), 1L)
  expect_identical(stabilize_present(list(a = 1)), list(a = 1))
  expect_identical(stabilize_present(mtcars), mtcars)
})

test_that("stabilize_present() errors for NULL (#110)", {
  expect_error(
    stabilize_present(NULL),
    class = .compile_dash("stbl", "error", "bad_null")
  )
  expect_snapshot(
    stabilize_present(NULL),
    error = TRUE
  )
})

test_that("stabilize_present() works as an element spec in stabilize_lst() (#110)", {
  given <- list(data = mtcars)
  expect_identical(
    stabilize_lst(given, data = stabilize_present),
    given
  )
  expect_error(
    stabilize_lst(list(data = NULL), data = stabilize_present),
    class = .compile_dash("stbl", "error", "bad_null")
  )
})
