test_that("compile_pkg_condition_classes() compiles condition class chains", {
  expect_equal(
    compile_pkg_condition_classes("wrapped"),
    "wrapped-condition"
  )
  expect_equal(
    compile_pkg_condition_classes("wrapped", "error"),
    c("wrapped-error", "wrapped-condition")
  )
  expect_equal(
    compile_pkg_condition_classes("wrapped", "error", "my_subclass"),
    c("wrapped-error-my_subclass", "wrapped-error", "wrapped-condition")
  )
})

test_that("compile_pkg_error_classes() compiles error class chains", {
  expect_equal(
    compile_pkg_error_classes("wrapped"),
    c("wrapped-error", "wrapped-condition")
  )
  expect_equal(
    compile_pkg_error_classes("wrapped", "my_subclass"),
    c("wrapped-error-my_subclass", "wrapped-error", "wrapped-condition")
  )
})

test_that("pkg_abort() throws the expected error", {
  wrapped_abort <- function(message, subclass, ...) {
    pkg_abort("wrapped", message, subclass, ...)
  }
  expect_error(
    wrapped_abort("A message.", "a_subclass"),
    class = "wrapped-error-a_subclass"
  )
  expect_error(
    wrapped_abort("A message.", "a_subclass"),
    class = "wrapped-error"
  )
  expect_error(
    wrapped_abort("A message.", "a_subclass"),
    class = "wrapped-condition"
  )
  expect_snapshot(
    wrapped_abort("A message.", "a_subclass"),
    error = TRUE
  )
})

test_that("pkg_abort() uses parent when provided", {
  wrapped_abort <- function(message, subclass, ...) {
    pkg_abort("wrapped", message, subclass, ...)
  }
  parent_cnd <- rlang::catch_cnd(cli::cli_abort("parent message"))
  expect_snapshot(
    wrapped_abort("child message", "child_class", parent = parent_cnd),
    error = TRUE
  )
})

test_that("pkg_abort() passes dots to cli_abort()", {
  wrapped_abort <- function(message, subclass, ...) {
    pkg_abort("wrapped", message, subclass, ...)
  }
  expect_error(
    wrapped_abort("A message.", "a_subclass", .internal = TRUE),
    class = "wrapped-error-a_subclass"
  )
  expect_snapshot(
    wrapped_abort("A message.", "a_subclass", .internal = TRUE),
    error = TRUE
  )
})

test_that("pkg_abort() uses message_env when provided", {
  wrapped_abort <- function(message, subclass, ...) {
    pkg_abort("wrapped", message, subclass, ...)
  }
  var <- "a locally defined var"
  msg_env <- new.env()
  msg_env$var <- "a custom environment"
  expect_snapshot(
    wrapped_abort(
      "This message comes from {var}.",
      "subclass",
      message_env = msg_env
    ),
    error = TRUE
  )
})

test_that("expect_pkg_error_classes() tests expressions for classes", {
  expect_success({
    expect_pkg_error_classes(
      {
        rlang::abort(
          "A message.",
          class = compile_pkg_error_classes("a_pkg", "a_class")
        )
      },
      "a_pkg",
      "a_class"
    )
  })
  # Can't use expect_failure() for wrapped expect_error().
  expect_error(
    {
      expect_pkg_error_classes(
        {
          rlang::abort(
            "A message.",
            class = compile_pkg_error_classes("a_pkg", "a_class")
          )
        },
        "a_pkg",
        "a_different_class"
      )
    },
    "A message"
  )
})
