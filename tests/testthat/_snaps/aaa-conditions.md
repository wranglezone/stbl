# .stbl_abort() throws the expected error (#95)

    Code
      (expect_pkg_error_classes(.stbl_abort("A message.", "a_subclass"), "stbl",
      "a_subclass"))
    Output
      <error/stbl-error-a_subclass>
      Error:
      ! A message.

# .stbl_warn() throws the expected warning (#213)

    Code
      .stbl_warn("A message.", "a_subclass")
    Condition
      Warning:
      A message.

# .stbl_inform() throws the expected message (#213)

    Code
      .stbl_inform("A message.", "a_subclass")
    Message
      A message.

# .stop_cant_coerce() throws the expected error (#95)

    Code
      (expect_pkg_error_classes(.stop_cant_coerce("character", "integer", "my_arg",
        rlang::current_env()), "stbl", "coerce", "integer"))
    Output
      <error/stbl-error-coerce-integer>
      Error:
      ! Can't coerce `my_arg` <character> to <integer>.

# .stop_cant_coerce() uses additional_msg when provided (#95)

    Code
      .stop_cant_coerce("character", "integer", "my_arg", rlang::current_env(),
      additional_msg = c(x = "An extra message."))
    Condition
      Error:
      ! Can't coerce `my_arg` <character> to <integer>.
      x An extra message.

# .stop_must() throws the expected error (#95)

    Code
      (expect_pkg_error_classes(.stop_must("must be a foo.", "my_arg", rlang::current_env()),
      "stbl", "must"))
    Output
      <error/stbl-error-must>
      Error:
      ! `my_arg` must be a foo.

# .stop_must() handles subclasses (#95)

    Code
      (expect_pkg_error_classes(.stop_must("must be a foo.", "my_arg", rlang::current_env(),
      subclass = "my_custom_class"), "stbl", "my_custom_class"))
    Output
      <error/stbl-error-my_custom_class>
      Error:
      ! `my_arg` must be a foo.

# .stop_must() uses additional_msg when provided (#95)

    Code
      .stop_must("must be a foo.", "my_arg", rlang::current_env(), additional_msg = c(
        `*` = "Some details."))
    Condition
      Error:
      ! `my_arg` must be a foo.
      * Some details.

# .stop_null() throws the expected error (#95)

    Code
      (expect_pkg_error_classes(.stop_null("my_arg", rlang::current_env()), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `my_arg` must not be <NULL>.

# .stop_incompatible() throws the expected error (#95)

    Code
      (expect_pkg_error_classes(.stop_incompatible("character", integer(), c(FALSE,
        TRUE, FALSE, TRUE), "some reason", "my_arg", rlang::current_env()), "stbl",
      "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `my_arg` <character> must be coercible to <integer>
      x Can't convert some values due to some reason.
      * Locations: 2 and 4

# .stop_incompatible() passes dots (#95)

    Code
      (expect_pkg_error_classes(.stop_incompatible("character", integer(), c(FALSE,
        TRUE, FALSE, TRUE), "some reason", "my_arg", rlang::current_env(), .internal = TRUE),
      "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `my_arg` <character> must be coercible to <integer>
      x Can't convert some values due to some reason.
      * Locations: 2 and 4
      i This is an internal error that was detected in the stbl package.
        Please report it at <https://github.com/wranglezone/stbl/issues> with a reprex (<https://tidyverse.org/help/>) and the full backtrace.

