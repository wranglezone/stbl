# Extracted from test-pkg_abort.R:73

# test -------------------------------------------------------------------------
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
