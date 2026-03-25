# pkg_abort() throws the expected error (#136)

    Code
      wrapped_abort("A message.", "a_subclass")
    Condition
      Error in `wrapped_abort()`:
      ! A message.

# pkg_abort() uses parent when provided (#136)

    Code
      wrapped_abort("child message", "child_class", parent = parent_cnd)
    Condition
      Error in `wrapped_abort()`:
      ! child message
      Caused by error:
      ! parent message

# pkg_abort() passes dots to cli_abort() (#136)

    Code
      wrapped_abort("A message.", "a_subclass", .internal = TRUE)
    Condition
      Error in `wrapped_abort()`:
      ! A message.
      i This is an internal error.

# pkg_abort() uses message_env when provided (#136)

    Code
      wrapped_abort("This message comes from {var}.", "subclass", message_env = msg_env)
    Condition
      Error in `wrapped_abort()`:
      ! This message comes from a custom environment.

# expect_pkg_error_snapshot() snapshots error class and message (#188)

    Code
      (expect_pkg_error_classes(pkg_abort("stbl", "A snapshot error.",
        "snapshot_subclass"), "stbl", "snapshot_subclass"))
    Output
      <error/stbl-error-snapshot_subclass>
      Error:
      ! A snapshot error.

# expect_pkg_error_snapshot() works with multiple class components (#188)

    Code
      (expect_pkg_error_classes(pkg_abort("stbl", "A nested error.", c("outer",
        "inner")), "stbl", "outer", "inner"))
    Output
      <error/stbl-error-outer-inner>
      Error:
      ! A nested error.

# expect_pkg_error_snapshot() works from an env without stbl attached (#noissue)

    Code
      (expect_pkg_error_classes(pkg_abort("otherpkg", "Foreign env error.",
        "foreign_subclass"), "otherpkg", "foreign_subclass"))
    Output
      <error/otherpkg-error-foreign_subclass>
      Error:
      ! Foreign env error.

