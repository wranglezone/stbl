# .to_null() errors when NULL isn't allowed (#129)

    Code
      .to_null(given, allow_null = FALSE)
    Condition
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_to_null(given, allow_null = FALSE)
    Condition
      Error in `wrapped_to_null()`:
      ! `val` must not be <NULL>.

# .to_null() errors for bad allow_null (#129)

    Code
      .to_null(NULL, allow_null = NULL)
    Condition
      Error:
      ! `allow_null` must not be <NULL>.

---

    Code
      .to_null(NULL, allow_null = "fish")
    Condition
      Error:
      ! `allow_null` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1

---

    Code
      wrapped_to_null(NULL, allow_null = "fish")
    Condition
      Error in `wrapped_to_null()`:
      ! `allow_null` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1

# .to_null() errors informatively for missing value (#129)

    Code
      .to_null()
    Condition
      Error:
      ! `unknown arg` must not be missing.

