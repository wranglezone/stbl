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

# expect_pkg_message_snapshot() snapshots message class and message (#213)

    Code
      (expect_pkg_message_classes(pkg_inform("stbl", "A snapshot message.",
        "snapshot_subclass"), "stbl", "snapshot_subclass"))
    Output
      <message/stbl-message-snapshot_subclass>
      Message:
      A snapshot message.

# expect_pkg_message_snapshot() works with multiple class components (#213)

    Code
      (expect_pkg_message_classes(pkg_inform("stbl", "A nested message.", c("outer",
        "inner")), "stbl", "outer", "inner"))
    Output
      <message/stbl-message-outer-inner>
      Message:
      A nested message.

# expect_pkg_message_snapshot() works from an env without stbl attached (#213)

    Code
      (expect_pkg_message_classes(pkg_inform("otherpkg", "Foreign env message.",
        "foreign_subclass"), "otherpkg", "foreign_subclass"))
    Output
      <message/otherpkg-message-foreign_subclass>
      Message:
      Foreign env message.

