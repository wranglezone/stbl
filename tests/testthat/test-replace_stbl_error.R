test_that("replace_stbl_error() replaces the message of a matching stbl error (#178)", {
  result_fn <- function(x) {
    replace_stbl_error(
      to_chr(x),
      subclass = c("coerce", "character"),
      message = "Custom message."
    )
  }
  expect_snapshot(result_fn(data.frame()), error = TRUE)
})

test_that("replace_stbl_error() preserves the original call (#178)", {
  my_fn <- function(x) {
    replace_stbl_error(
      to_chr(x),
      subclass = c("coerce", "character"),
      message = "Custom message."
    )
  }
  err <- rlang::catch_cnd(my_fn(data.frame()), "error")
  expect_equal(
    rlang::call_name(err$call),
    "my_fn"
  )
})

test_that("replace_stbl_error() preserves the original class hierarchy (#178)", {
  my_fn <- function(x) {
    replace_stbl_error(
      to_chr(x),
      subclass = c("coerce", "character"),
      message = "Custom message."
    )
  }
  err <- rlang::catch_cnd(my_fn(data.frame()), "error")
  expect_in("stbl-error-coerce-character", class(err))
  expect_in("stbl-error-coerce", class(err))
  expect_in("stbl-error", class(err))
})

test_that("replace_stbl_error() prepends additional_class when provided (#178)", {
  my_fn <- function(x) {
    replace_stbl_error(
      to_chr(x),
      subclass = c("coerce", "character"),
      message = "Custom message.",
      additional_class = "mypkg-error-bad_chr"
    )
  }
  err <- rlang::catch_cnd(my_fn(data.frame()), "error")
  expect_equal(class(err)[[1L]], "mypkg-error-bad_chr")
  expect_in("stbl-error-coerce-character", class(err))
})

test_that("replace_stbl_error() returns value when no error is thrown (#178)", {
  result <- replace_stbl_error(
    to_chr("hello"),
    subclass = c("coerce", "character"),
    message = "Custom message."
  )
  expect_equal(result, "hello")
})

test_that("replace_stbl_error() does not catch non-matching stbl errors (#178)", {
  expect_error(
    replace_stbl_error(
      stabilize_chr(NULL, allow_null = FALSE),
      subclass = c("coerce", "character"),
      message = "Custom message."
    ),
    class = "stbl-error-bad_null"
  )
})

test_that("replace_stbl_error() catches broad subclass (#178)", {
  my_fn <- function(x) {
    replace_stbl_error(
      to_chr(x),
      subclass = c("coerce"),
      message = "Custom coerce message."
    )
  }
  err <- rlang::catch_cnd(my_fn(data.frame()), "error")
  expect_match(conditionMessage(err), "Custom coerce message.")
})

test_that("replace_stbl_error() formats message with cli markup (#178)", {
  my_fn <- function(x) {
    replace_stbl_error(
      to_chr(x),
      subclass = c("coerce", "character"),
      message = "{.arg x} must be a character string."
    )
  }
  expect_snapshot(my_fn(data.frame()), error = TRUE)
})
