# .to_null() errors when NULL isn't allowed (#129)

    Code
      .to_null(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_null(given, allow_null = FALSE)
    Condition <stbl-error-bad_null>
      Error in `wrapped_to_null()`:
      ! `val` must not be <NULL>.

# .to_null() errors for bad allow_null (#129, #310)

    Code
      .to_null(NULL, allow_null = NULL)
    Condition <stbl-error-bad_null>
      Error:
      ! `allow_null` must not be <NULL>.

---

    Code
      .to_null(NULL, allow_null = "fish")
    Condition <stbl-error-incompatible_values-logical>
      Error:
      ! `allow_null` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1
      * Values: "fish"

---

    Code
      wrapped_to_null(NULL, allow_null = "fish")
    Condition <stbl-error-incompatible_values-logical>
      Error in `wrapped_to_null()`:
      ! `allow_null` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1
      * Values: "fish"

# .to_null() errors informatively for missing value (#129)

    Code
      .to_null()
    Condition <stbl-error-must>
      Error:
      ! `unknown arg` must not be missing.

