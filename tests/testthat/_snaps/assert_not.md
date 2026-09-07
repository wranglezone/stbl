# assert_not() errors when spec succeeds outright (#289)

    Code
      assert_not(1L, stabilize_int)
    Condition <stbl-error-matched_spec>
      Error:
      ! `1L` must not match "stabilize_int".

# assert_not() works with to_* functions as spec (#289)

    Code
      assert_not("1", to_int)
    Condition <stbl-error-matched_spec>
      Error:
      ! `"1"` must not match "to_int".

# assert_not() composes with stabilize_all_of() (#289)

    Code
      stabilize_all_of("1", stabilize_chr, not_one)
    Condition <stbl-error-cant_stabilize_all_of>
      Error:
      ! `"1"` must match all of the provided stabilizers.
      x `x` must not match "specify_chr(allowed_values = \"1\")".

