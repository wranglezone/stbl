test_that("replace_stbl_error() replaces the message of a matching stbl error (#178)", {
  result_fn <- function(x) {
    replace_stbl_error(
      to_chr(x),
      subclass = c("coerce", "character"),
      message = "Custom message."
    )
  }
  expect_pkg_error_snapshot(
    result_fn(data.frame()),
    "stbl",
    c("coerce", "character")
  )
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
  expect_pkg_error_classes(
    my_fn(data.frame()),
    "stbl",
    "coerce",
    "character"
  )
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
  expect_contains(
    class(err),
    .compile_pkg_error_classes("stbl", "coerce", "character")
  )
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
  expect_pkg_error_classes(
    replace_stbl_error(
      stabilize_chr(NULL, allow_null = FALSE),
      subclass = c("coerce", "character"),
      message = "Custom message."
    ),
    "stbl",
    "bad_null"
  )
})

test_that("replace_stbl_error() catches any stbl error by default (#334)", {
  my_fn <- function(x) {
    replace_stbl_error(
      to_chr(x),
      message = "Custom message."
    )
  }
  expect_error(
    my_fn(data.frame()),
    "Custom message.",
    class = "stbl-error-coerce-character"
  )

  my_fn2 <- function(x) {
    replace_stbl_error(
      stabilize_chr(x, allow_null = FALSE),
      message = "Custom message."
    )
  }
  expect_error(
    my_fn2(NULL),
    "Custom message.",
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
  expect_equal(conditionMessage(err), "Custom coerce message.")
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
