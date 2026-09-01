test_that("ignore_stbl_error() returns NULL for a matching stbl error (#178)", {
  result <- to_chr(data.frame()) |>
    ignore_stbl_error(c("coerce", "character"))
  expect_null(result)
})

test_that("ignore_stbl_error() returns value when no error is thrown (#178)", {
  result <- to_chr("hello") |>
    ignore_stbl_error(c("coerce", "character"))
  expect_equal(result, "hello")
})

test_that("ignore_stbl_error() does not catch non-matching stbl errors (#178)", {
  stabilize_chr(NULL, allow_null = FALSE) |>
    ignore_stbl_error(c("coerce", "character")) |>
    expect_pkg_error_classes("stbl", "bad_null")
})

test_that("ignore_stbl_error() catches any stbl error by default (#334)", {
  result <- to_chr(data.frame()) |>
    ignore_stbl_error()
  expect_null(result)

  stabilize_chr(NULL, allow_null = FALSE) |>
    ignore_stbl_error() |>
    expect_null()
})

test_that("ignore_stbl_error() catches broad subclass (#178)", {
  expect_null(
    ignore_stbl_error(
      to_chr(data.frame()),
      c("coerce")
    )
  )
})

test_that("ignore_stbl_error() does not catch non-stbl errors (#178)", {
  expect_error(
    ignore_stbl_error(
      stop("a plain error"),
      subclass = c("coerce", "character")
    ),
    "a plain error"
  )
})
