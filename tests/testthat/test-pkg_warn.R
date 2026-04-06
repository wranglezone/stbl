test_that(".compile_pkg_warning_classes() compiles warning class chains (#213)", {
  expect_setequal(
    .compile_pkg_warning_classes("wrapped"),
    c("wrapped-warning", "wrapped-condition")
  )
  expect_setequal(
    .compile_pkg_warning_classes("wrapped", "my_subclass"),
    c("wrapped-warning-my_subclass", "wrapped-warning", "wrapped-condition")
  )
})

test_that("pkg_warn() signals the expected warning (#213)", {
  wrapped_warn <- function(message, subclass, ...) {
    pkg_warn("wrapped", message, subclass, ...)
  }
  warning_cnd <- expect_warning(
    wrapped_warn("A message.", "a_subclass")
  )
  expect_s3_class(
    warning_cnd,
    c(
      .compile_pkg_warning_classes("wrapped", "a_subclass"),
      # Added by rlang::warn()
      "rlang_warning",
      "warning",
      "condition"
    ),
    exact = TRUE
  )
  expect_snapshot(
    wrapped_warn("A message.", "a_subclass"),
    cnd_class = TRUE
  )
})

test_that("pkg_warn() uses parent when provided (#213)", {
  wrapped_warn <- function(message, subclass, ...) {
    pkg_warn("wrapped", message, subclass, ...)
  }
  parent_cnd <- rlang::catch_cnd(cli::cli_warn("parent message"))
  expect_snapshot(
    wrapped_warn("child message", "child_class", parent = parent_cnd),
    cnd_class = TRUE
  )
})

test_that("pkg_warn() passes dots to cli_warn() (#213)", {
  wrapped_warn <- function(message, subclass, ...) {
    pkg_warn("wrapped", message, subclass, ...)
  }
  expect_warning(
    wrapped_warn("A message.", "a_subclass", .frequency = "always"),
    class = "wrapped-warning-a_subclass"
  )
})

test_that("pkg_warn() uses message_env when provided (#213)", {
  wrapped_warn <- function(message, subclass, ...) {
    pkg_warn("wrapped", message, subclass, ...)
  }
  var <- "a locally defined var"
  msg_env <- new.env()
  msg_env$var <- "a custom environment"
  expect_snapshot(
    wrapped_warn(
      "This message comes from {var}.",
      "subclass",
      message_env = msg_env
    ),
    cnd_class = TRUE
  )
})

test_that("expect_pkg_warning_classes() tests expressions for classes (#213)", {
  expect_success({
    expect_pkg_warning_classes(
      {
        rlang::warn(
          "A message.",
          class = .compile_pkg_warning_classes("a_pkg", "a_class")
        )
      },
      "a_pkg",
      "a_class"
    )
  })
  expect_failure(
    {
      expect_pkg_warning_classes(
        {
          rlang::warn(
            "A message.",
            class = .compile_pkg_warning_classes("a_pkg", "a_class")
          )
        },
        "a_pkg",
        "a_different_class"
      )
    },
    "Actual class"
  )
})

test_that("expect_pkg_warning_snapshot() snapshots warning class and message (#213)", {
  skip_on_covr()
  expect_pkg_warning_snapshot(
    pkg_warn("stbl", "A snapshot warning.", "snapshot_subclass"),
    "stbl",
    "snapshot_subclass"
  )
})

test_that("expect_pkg_warning_snapshot() works with multiple class components (#213)", {
  skip_on_covr()
  expect_pkg_warning_snapshot(
    pkg_warn("stbl", "A nested warning.", c("outer", "inner")),
    "stbl",
    "outer",
    "inner"
  )
})

test_that("expect_pkg_warning_snapshot() works from an env without stbl attached (#213)", {
  skip_on_covr()
  foreign_env <- new.env(parent = baseenv())
  foreign_env$pkg_warn <- pkg_warn
  foreign_env$expect_pkg_warning_snapshot <- expect_pkg_warning_snapshot
  local(
    {
      expect_pkg_warning_snapshot(
        pkg_warn("otherpkg", "Foreign env warning.", "foreign_subclass"),
        "otherpkg",
        "foreign_subclass"
      )
    },
    envir = foreign_env
  )
})

test_that("expect_pkg_warning_classes() works from an env without stbl attached (#213)", {
  foreign_env <- new.env(parent = baseenv())
  foreign_env$pkg_warn <- pkg_warn
  foreign_env$expect_pkg_warning_classes <- expect_pkg_warning_classes
  foreign_env$.compile_pkg_warning_classes <- .compile_pkg_warning_classes
  expect_success(
    local(
      expect_pkg_warning_classes(
        pkg_warn("otherpkg", "A message.", "a_class"),
        "otherpkg",
        "a_class"
      ),
      envir = foreign_env
    )
  )
})
