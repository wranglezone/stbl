test_that(".compile_pkg_message_classes() compiles message class chains (#213)", {
  expect_setequal(
    .compile_pkg_message_classes("wrapped"),
    c("wrapped-message", "wrapped-condition")
  )
  expect_setequal(
    .compile_pkg_message_classes("wrapped", "my_subclass"),
    c("wrapped-message-my_subclass", "wrapped-message", "wrapped-condition")
  )
})

test_that("pkg_inform() signals the expected message (#213)", {
  wrapped_inform <- function(message, subclass, ...) {
    pkg_inform("wrapped", message, subclass, ...)
  }
  message_cnd <- expect_message(
    wrapped_inform("A message.", "a_subclass")
  )
  expect_s3_class(
    message_cnd,
    c(
      .compile_pkg_message_classes("wrapped", "a_subclass"),
      # Added by rlang::inform()
      "rlang_message",
      "message",
      "condition"
    ),
    exact = TRUE
  )
  expect_snapshot(
    wrapped_inform("A message.", "a_subclass"),
    cnd_class = TRUE
  )
})

test_that("pkg_inform() uses parent when provided (#213)", {
  wrapped_inform <- function(message, subclass, ...) {
    pkg_inform("wrapped", message, subclass, ...)
  }
  parent_cnd <- rlang::catch_cnd(cli::cli_inform("parent message"))
  expect_snapshot(
    wrapped_inform("child message", "child_class", parent = parent_cnd),
    cnd_class = TRUE
  )
})

test_that("pkg_inform() uses message_env when provided (#213)", {
  wrapped_inform <- function(message, subclass, ...) {
    pkg_inform("wrapped", message, subclass, ...)
  }
  var <- "a locally defined var"
  msg_env <- new.env()
  msg_env$var <- "a custom environment"
  expect_snapshot(
    wrapped_inform(
      "This message comes from {var}.",
      "subclass",
      message_env = msg_env
    ),
    cnd_class = TRUE
  )
})

test_that("expect_pkg_message_classes() tests expressions for classes (#213)", {
  expect_success({
    expect_pkg_message_classes(
      {
        rlang::inform(
          "A message.",
          class = .compile_pkg_message_classes("a_pkg", "a_class")
        )
      },
      "a_pkg",
      "a_class"
    )
  })
  expect_failure(
    {
      expect_pkg_message_classes(
        {
          rlang::inform(
            "A message.",
            class = .compile_pkg_message_classes("a_pkg", "a_class")
          )
        },
        "a_pkg",
        "a_different_class"
      )
    },
    "Actual class"
  )
})

test_that("expect_pkg_message_snapshot() snapshots message class and message (#213)", {
  skip_on_covr()
  expect_pkg_message_snapshot(
    pkg_inform("stbl", "A snapshot message.", "snapshot_subclass"),
    "stbl",
    "snapshot_subclass"
  )
})

test_that("expect_pkg_message_snapshot() works with multiple class components (#213)", {
  skip_on_covr()
  expect_pkg_message_snapshot(
    pkg_inform("stbl", "A nested message.", c("outer", "inner")),
    "stbl",
    "outer",
    "inner"
  )
})

test_that("expect_pkg_message_snapshot() works from an env without stbl attached (#213)", {
  skip_on_covr()
  foreign_env <- new.env(parent = baseenv())
  foreign_env$pkg_inform <- pkg_inform
  foreign_env$expect_pkg_message_snapshot <- expect_pkg_message_snapshot
  local(
    {
      expect_pkg_message_snapshot(
        pkg_inform("otherpkg", "Foreign env message.", "foreign_subclass"),
        "otherpkg",
        "foreign_subclass"
      )
    },
    envir = foreign_env
  )
})

test_that("expect_pkg_message_classes() works from an env without stbl attached (#213)", {
  foreign_env <- new.env(parent = baseenv())
  foreign_env$pkg_inform <- pkg_inform
  foreign_env$expect_pkg_message_classes <- expect_pkg_message_classes
  foreign_env$.compile_pkg_message_classes <- .compile_pkg_message_classes
  expect_success(
    local(
      expect_pkg_message_classes(
        pkg_inform("otherpkg", "A message.", "a_class"),
        "otherpkg",
        "a_class"
      ),
      envir = foreign_env
    )
  )
})
