# pkg_warn() signals the expected warning (#213)

    Code
      wrapped_warn("A message.", "a_subclass")
    Condition <wrapped-warning-a_subclass>
      Warning in `wrapped_warn()`:
      A message.

# pkg_warn() uses parent when provided (#213)

    Code
      wrapped_warn("child message", "child_class", parent = parent_cnd)
    Condition <wrapped-warning-child_class>
      Warning in `wrapped_warn()`:
      child message
      Caused by warning:
      ! parent message

# pkg_warn() uses message_env when provided (#213)

    Code
      wrapped_warn("This message comes from {var}.", "subclass", message_env = msg_env)
    Condition <wrapped-warning-subclass>
      Warning in `wrapped_warn()`:
      This message comes from a custom environment.

# expect_pkg_warning_snapshot() snapshots warning class and message (#213, #301)

    Code
      pkg_warn("stbl", "A snapshot warning.", "snapshot_subclass")
    Condition <stbl-warning-snapshot_subclass>
      Warning:
      A snapshot warning.

# expect_pkg_warning_snapshot() works with multiple class components (#213, #301)

    Code
      pkg_warn("stbl", "A nested warning.", c("outer", "inner"))
    Condition <stbl-warning-outer-inner>
      Warning:
      A nested warning.

# expect_pkg_warning_snapshot() allows object definition inside expression (#234, #301)

    Code
      result <- warns_and_returns()
    Condition <stbl-warning-return_subclass>
      Warning in `warns_and_returns()`:
      A warning with a return value.

# expect_pkg_warning_snapshot() works from an env without stbl attached (#213, #301)

    Code
      pkg_warn("otherpkg", "Foreign env warning.", "foreign_subclass")
    Condition <otherpkg-warning-foreign_subclass>
      Warning:
      Foreign env warning.

