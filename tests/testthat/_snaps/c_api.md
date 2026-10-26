# .stbl_to() uses x_arg and call when supplied (#369)

    Code
      .stbl_to("a", logical(), x_arg = "my_arg", call = quote(my_fn()))
    Condition <stbl-error-incompatible_values-logical>
      Error in `my_fn()`:
      ! `my_arg` <character> must be coercible to <logical>
      x Can't convert some values due to unexpected strings (should be 'TRUE', 'FALSE', 'T', 'F', or an integer).
      * Locations: 1
      * Values: "a"

# .stbl_to() uses to_arg when supplied (#371)

    Code
      .stbl_to("a", logical(), x_arg = "my_arg", to_arg = "my_to")
    Condition <stbl-error-incompatible_values-logical>
      Error:
      ! Can't coerce `my_arg` <character> to match `my_to` <logical>.
      x Can't convert some values due to unexpected strings (should be 'TRUE', 'FALSE', 'T', 'F', or an integer).
      * Locations: 1
      * Values: "a"

# .stbl_to() doesn't derive a to_arg when it is NULL (#371)

    Code
      .stbl_to("a", logical(), x_arg = "my_arg")
    Condition <stbl-error-incompatible_values-logical>
      Error:
      ! `my_arg` <character> must be coercible to <logical>
      x Can't convert some values due to unexpected strings (should be 'TRUE', 'FALSE', 'T', 'F', or an integer).
      * Locations: 1
      * Values: "a"

