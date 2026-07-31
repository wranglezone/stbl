# pkg_inform() signals the expected message (#213)

    Code
      wrapped_inform("A message.", "a_subclass")
    Message <wrapped-message-a_subclass>
      A message.

# pkg_inform() uses parent when provided (#213)

    Code
      wrapped_inform("child message", "child_class", parent = parent_cnd)
    Message <wrapped-message-child_class>
      child message
      Caused by message:
      ! parent message

# pkg_inform() uses message_env when provided (#213)

    Code
      wrapped_inform("This message comes from {var}.", "subclass", message_env = msg_env)
    Message <wrapped-message-subclass>
      This message comes from a custom environment.

# expect_pkg_message_snapshot() snapshots message class and message (#213, #301)

    Code
      pkg_inform("stbl", "A snapshot message.", "snapshot_subclass")
    Message <stbl-message-snapshot_subclass>
      A snapshot message.

# expect_pkg_message_snapshot() works with multiple class components (#213, #301)

    Code
      pkg_inform("stbl", "A nested message.", c("outer", "inner"))
    Message <stbl-message-outer-inner>
      A nested message.

# expect_pkg_message_snapshot() allows object definition inside expression (#234, #301)

    Code
      result <- informs_and_returns()
    Message <stbl-message-return_subclass>
      A message with a return value.

# expect_pkg_message_snapshot() works from an env without stbl attached (#213, #301)

    Code
      pkg_inform("otherpkg", "Foreign env message.", "foreign_subclass")
    Message <otherpkg-message-foreign_subclass>
      Foreign env message.

