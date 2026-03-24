# Extracted from test-pkg_abort.R:139

# setup ------------------------------------------------------------------------
library(testthat)
test_env <- simulate_test_env(package = "stbl", path = "..")
attach(test_env, warn.conflicts = FALSE)

# test -------------------------------------------------------------------------
expect_failure(
    expect_pkg_error_snapshot(
      pkg_abort("stbl", "A snapshot error.", "snapshot_subclass"),
      "different_subclass",
      "stbl"
    ),
    "Actual class"
  )
