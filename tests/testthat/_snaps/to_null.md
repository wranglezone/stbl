# .to_null() errors when NULL isn't allowed (#129)

    Code
      (expect_pkg_error_classes(.to_null(given, allow_null = FALSE), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_null(given, allow_null = FALSE), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_to_null()`:
      ! `val` must not be <NULL>.

# .to_null() errors for bad allow_null (#129)

    Code
      (expect_pkg_error_classes(.to_null(NULL, allow_null = NULL), "stbl", "bad_null")
      )
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `allow_null` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(.to_null(NULL, allow_null = "fish"), "stbl",
      "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `allow_null` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1

---

    Code
      (expect_pkg_error_classes(wrapped_to_null(NULL, allow_null = "fish"), "stbl",
      "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error in `wrapped_to_null()`:
      ! `allow_null` <character> must be coercible to <logical>
      x Can't convert some values due to incompatible values.
      * Locations: 1

# .to_null() errors informatively for missing value (#129)

    Code
      (expect_pkg_error_classes(.to_null(), "stbl", "must"))
    Output
      <error/stbl-error-must>
      Error:
      ! `unknown arg` must not be missing.

