test_that("assert_present() returns any non-NULL value unchanged (#110, #299)", {
  expect_identical(assert_present("hello"), "hello")
  expect_identical(assert_present(1L), 1L)
  expect_identical(assert_present(list(a = 1)), list(a = 1))
  expect_identical(assert_present(mtcars), mtcars)
})

test_that("assert_present() errors for NULL (#110, #299)", {
  expect_pkg_error_snapshot(assert_present(NULL), "stbl", "bad_null")
})

test_that("assert_present() works as an element spec in stabilize_lst() (#110, #299)", {
  given <- list(data = mtcars)
  expect_identical(
    stabilize_lst(given, data = assert_present),
    given
  )
  expect_pkg_error_classes(
    stabilize_lst(list(data = NULL), data = assert_present),
    "stbl",
    "bad_null"
  )
})
