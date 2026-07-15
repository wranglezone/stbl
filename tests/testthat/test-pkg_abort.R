test_that(".compile_pkg_condition_classes() compiles condition class chains (#136)", {
  expect_setequal(
    .compile_pkg_condition_classes("wrapped"),
    c("wrapped-condition")
  )
  expect_setequal(
    .compile_pkg_condition_classes("wrapped", "error"),
    c("wrapped-error", "wrapped-condition")
  )
  expect_setequal(
    .compile_pkg_condition_classes("wrapped", "error", "my_subclass"),
    c("wrapped-error-my_subclass", "wrapped-error", "wrapped-condition")
  )
})

test_that(".compile_pkg_error_classes() compiles error class chains (#136)", {
  expect_setequal(
    .compile_pkg_error_classes("wrapped"),
    c("wrapped-error", "wrapped-condition")
  )
  expect_setequal(
    .compile_pkg_error_classes("wrapped", "my_subclass"),
    c("wrapped-error-my_subclass", "wrapped-error", "wrapped-condition")
  )
})

test_that("pkg_abort() throws the expected error (#136)", {
  wrapped_abort <- function(message, subclass, ...) {
    pkg_abort("wrapped", message, subclass, ...)
  }
  error_cnd <- expect_error(
    wrapped_abort("A message.", "a_subclass")
  )
  expect_s3_class(
    error_cnd,
    c(
      .compile_pkg_error_classes("wrapped", "a_subclass"),
      # Added by rlang::abort()
      "rlang_error",
      "error",
      "condition"
    ),
    exact = TRUE
  )
  expect_snapshot(
    wrapped_abort("A message.", "a_subclass"),
    error = TRUE
  )
})

test_that("pkg_abort() uses parent when provided (#136)", {
  wrapped_abort <- function(message, subclass, ...) {
    pkg_abort("wrapped", message, subclass, ...)
  }
  parent_cnd <- rlang::catch_cnd(cli::cli_abort("parent message"))
  expect_snapshot(
    wrapped_abort("child message", "child_class", parent = parent_cnd),
    error = TRUE
  )
})

test_that("pkg_abort() passes dots to cli_abort() (#136)", {
  skip_if_not_installed("stringr")
  wrapped_abort <- function(message, subclass, ...) {
    pkg_abort("wrapped", message, subclass, ...)
  }
  expect_error(
    wrapped_abort("A message.", "a_subclass", .internal = TRUE),
    class = "wrapped-error-a_subclass"
  )
  expect_snapshot(
    wrapped_abort("A message.", "a_subclass", .internal = TRUE),
    error = TRUE,
    transform = function(x) {
      stringr::str_replace(
        x,
        "This is an internal error.+$",
        "This is an internal error."
      ) |>
        stringr::str_subset(
          "\\s*Please report it at",
          negate = TRUE
        )
    }
  )
})

test_that("pkg_abort() uses message_env when provided (#136)", {
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

test_that("expect_pkg_error_classes() tests expressions for classes (#136)", {
  expect_success({
    expect_pkg_error_classes(
      {
        rlang::abort(
          "A message.",
          class = .compile_pkg_error_classes("a_pkg", "a_class")
        )
      },
      "a_pkg",
      "a_class"
    )
  })
  expect_failure(
    {
      expect_pkg_error_classes(
        {
          rlang::abort(
            "A message.",
            class = .compile_pkg_error_classes("a_pkg", "a_class")
          )
        },
        "a_pkg",
        "a_different_class"
      )
    },
    "Actual class"
  )
})

test_that(".is_covr_count_call() identifies covr counter calls (#253)", {
  count_sym <- call(":::", as.symbol("covr"), as.symbol("count"))
  expect_true(.is_covr_count_call(as.call(list(count_sym, "key"))))
  expect_false(.is_covr_count_call(quote(some_fn("key"))))
  expect_false(.is_covr_count_call(quote(covr::count("key"))))
  expect_false(.is_covr_count_call(123L))
})

test_that(".strip_covr_from_expr() removes covr counter wrappers (#253)", {
  count_sym <- call(":::", as.symbol("covr"), as.symbol("count"))
  make_wrapped <- function(key, val) {
    call("if", TRUE, call("{", as.call(list(count_sym, key)), val))
  }
  # Simple case: wrapped call
  expect_identical(
    .strip_covr_from_expr(make_wrapped("k1", quote(to_fn(NULL)))),
    quote(to_fn(NULL))
  )
  # Nested: wrapped arguments within a wrapped call
  instrumented <- call(
    "to_fn",
    make_wrapped("k1", NULL),
    allow_null = make_wrapped("k2", FALSE)
  )
  expect_identical(
    .strip_covr_from_expr(instrumented),
    quote(to_fn(NULL, allow_null = FALSE))
  )
  # Degenerate case: counter-only block (empty splice site) -> NULL
  counter_only <- call("if", TRUE, call("{", as.call(list(count_sym, "k3"))))
  expect_null(.strip_covr_from_expr(counter_only))
  # NULL results are dropped from `{` blocks
  block_with_counter_only <- call(
    "{",
    counter_only,
    quote(to_fn(NULL))
  )
  expect_identical(
    .strip_covr_from_expr(block_with_counter_only),
    quote({
      to_fn(NULL)
    })
  )
  # Non-covr expressions are unchanged
  expect_identical(
    .strip_covr_from_expr(quote(to_fn(NULL))),
    quote(to_fn(NULL))
  )
})

test_that("expect_pkg_error_snapshot() snapshots error class and message (#188)", {
  expect_pkg_error_snapshot(
    pkg_abort("stbl", "A snapshot error.", "snapshot_subclass"),
    "stbl",
    "snapshot_subclass"
  )
})

test_that("expect_pkg_error_snapshot() works with multiple class components (#188)", {
  expect_pkg_error_snapshot(
    pkg_abort("stbl", "A nested error.", c("outer", "inner")),
    "stbl",
    "outer",
    "inner"
  )
})

test_that("expect_pkg_error_snapshot() works from an env without stbl attached (#188)", {
  # Simulate calling from another package where expect_pkg_error_classes
  # isn't directly available in the caller's environment.
  foreign_env <- new.env(parent = baseenv())
  foreign_env$pkg_abort <- pkg_abort
  foreign_env$expect_pkg_error_snapshot <- expect_pkg_error_snapshot
  local(
    {
      expect_pkg_error_snapshot(
        pkg_abort("otherpkg", "Foreign env error.", "foreign_subclass"),
        "otherpkg",
        "foreign_subclass"
      )
    },
    envir = foreign_env
  )
})

test_that("expect_pkg_error_classes() works from an env without stbl attached (#188)", {
  foreign_env <- new.env(parent = baseenv())
  foreign_env$pkg_abort <- pkg_abort
  foreign_env$expect_pkg_error_classes <- expect_pkg_error_classes
  foreign_env$.compile_pkg_error_classes <- .compile_pkg_error_classes
  expect_success(
    local(
      expect_pkg_error_classes(
        pkg_abort("otherpkg", "A message.", "a_class"),
        "otherpkg",
        "a_class"
      ),
      envir = foreign_env
    )
  )
})
