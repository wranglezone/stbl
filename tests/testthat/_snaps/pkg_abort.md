# pkg_abort() throws the expected error

    Code
      wrapped_abort("A message.", "a_subclass")
    Condition
      Error in `wrapped_abort()`:
      ! A message.

# pkg_abort() uses parent when provided

    Code
      wrapped_abort("child message", "child_class", parent = parent_cnd)
    Condition
      Error in `wrapped_abort()`:
      ! child message
      Caused by error:
      ! parent message

# pkg_abort() passes dots to cli_abort()

    Code
      wrapped_abort("A message.", "a_subclass", .internal = TRUE)
    Condition
      Error in `wrapped_abort()`:
      ! A message.
      i This is an internal error that was detected in the stbl package.
        Please report it at <https://github.com/wranglezone/stbl/issues> with a reprex (<https://tidyverse.org/help/>) and the full backtrace.

# pkg_abort() uses message_env when provided

    Code
      wrapped_abort("This message comes from {var}.", "subclass", message_env = msg_env)
    Condition
      Error in `wrapped_abort()`:
      ! This message comes from a custom environment.

