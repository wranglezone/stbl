# .stbl_abort() throws the expected error

    Code
      .stbl_abort("A message.", "a_subclass")
    Condition
      Error:
      ! A message.

# .stop_cant_coerce() throws the expected error

    Code
      .stop_cant_coerce("character", "integer", "my_arg", rlang::current_env())
    Condition
      Error:
      ! Can't coerce `my_arg` <character> to <integer>.

# .stop_cant_coerce() uses additional_msg when provided

    Code
      .stop_cant_coerce("character", "integer", "my_arg", rlang::current_env(),
      additional_msg = c(x = "An extra message."))
    Condition
      Error:
      ! Can't coerce `my_arg` <character> to <integer>.
      x An extra message.

# .stop_must() throws the expected error

    Code
      .stop_must("must be a foo.", "my_arg", rlang::current_env())
    Condition
      Error:
      ! `my_arg` must be a foo.

# .stop_must() handles subclasses

    Code
      .stop_must("must be a foo.", "my_arg", rlang::current_env(), subclass = "my_custom_class")
    Condition
      Error:
      ! `my_arg` must be a foo.

# .stop_must() uses additional_msg when provided

    Code
      .stop_must("must be a foo.", "my_arg", rlang::current_env(), additional_msg = c(
        `*` = "Some details."))
    Condition
      Error:
      ! `my_arg` must be a foo.
      * Some details.

# .stop_null() throws the expected error

    Code
      .stop_null("my_arg", rlang::current_env())
    Condition
      Error:
      ! `my_arg` must not be <NULL>.

# .stop_incompatible() throws the expected error

    Code
      .stop_incompatible("character", integer(), c(FALSE, TRUE, FALSE, TRUE),
      "some reason", "my_arg", rlang::current_env())
    Condition
      Error:
      ! `my_arg` <character> must be coercible to <integer>
      x Can't convert some values due to some reason.
      * Locations: 2 and 4

# .stop_incompatible() passes dots

    Code
      .stop_incompatible("character", integer(), c(FALSE, TRUE, FALSE, TRUE),
      "some reason", "my_arg", rlang::current_env(), .internal = TRUE)
    Condition
      Error:
      ! `my_arg` <character> must be coercible to <integer>
      x Can't convert some values due to some reason.
      * Locations: 2 and 4
      i This is an internal error that was detected in the stbl package.
        Please report it at <https://github.com/wranglezone/stbl/issues> with a reprex (<https://tidyverse.org/help/>) and the full backtrace.

