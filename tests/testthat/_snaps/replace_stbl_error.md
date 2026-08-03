# replace_stbl_error() replaces the message of a matching stbl error (#178)

    Code
      result_fn(data.frame())
    Condition <stbl-error-coerce-character>
      Error in `result_fn()`:
      ! Custom message.

# replace_stbl_error() formats message with cli markup (#178)

    Code
      my_fn(data.frame())
    Condition
      Error in `my_fn()`:
      ! `x` must be a character string.

