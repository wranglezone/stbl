# to_dbl() respects allow_null (#23)

    Code
      (expect_pkg_error_classes(to_dbl(given, allow_null = FALSE), "stbl", "bad_null")
      )
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_dbl(given, allow_null = FALSE), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_to_dbl()`:
      ! `val` must not be <NULL>.

# to_dbl() respects coerce_character (#23)

    Code
      (expect_pkg_error_classes(to_dbl(given, coerce_character = FALSE), "stbl",
      "coerce", "double"))
    Output
      <error/stbl-error-coerce-double>
      Error:
      ! Can't coerce `given` <character> to <double>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_dbl(given, coerce_character = FALSE),
      "stbl", "coerce", "double"))
    Output
      <error/stbl-error-coerce-double>
      Error in `wrapped_to_dbl()`:
      ! Can't coerce `val` <character> to <double>.

# to_dbl() errors informatively for bad chrs (#23)

    Code
      (expect_pkg_error_classes(to_dbl(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `given` <character> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 2

---

    Code
      (expect_pkg_error_classes(wrapped_to_dbl(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error in `wrapped_to_dbl()`:
      ! `val` <character> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 2

# to_dbl() errors informatively for bad complexes (#23)

    Code
      (expect_pkg_error_classes(to_dbl(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `given` <complex> must be coercible to <double>
      x Can't convert some values due to non-zero complex components.
      * Locations: 1

---

    Code
      (expect_pkg_error_classes(wrapped_to_dbl(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error in `wrapped_to_dbl()`:
      ! `val` <complex> must be coercible to <double>
      x Can't convert some values due to non-zero complex components.
      * Locations: 1

# to_dbl() respects coerce_factor (#23)

    Code
      (expect_pkg_error_classes(to_dbl(given, coerce_factor = FALSE), "stbl",
      "coerce", "double"))
    Output
      <error/stbl-error-coerce-double>
      Error:
      ! Can't coerce `given` <factor> to <double>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_dbl(given, coerce_factor = FALSE), "stbl",
      "coerce", "double"))
    Output
      <error/stbl-error-coerce-double>
      Error in `wrapped_to_dbl()`:
      ! Can't coerce `val` <factor> to <double>.

# to_dbl() errors informatively for bad factors (#23)

    Code
      (expect_pkg_error_classes(to_dbl(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `given` <factor> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 25, and 26

---

    Code
      (expect_pkg_error_classes(wrapped_to_dbl(given), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error in `wrapped_to_dbl()`:
      ! `val` <factor> must be coercible to <double>
      x Can't convert some values due to incompatible values.
      * Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 25, and 26

# to_dbl() works for lists (#128, #273)

    Code
      (expect_pkg_error_classes(to_dbl(list(1.1, 1:5)), "stbl", "incompatible_type"))
    Output
      <error/stbl-error-incompatible_type>
      Error:
      ! `list(1.1, 1:5)` <list> must be coercible to <double>
      x Can't convert some values due to incompatible element types.
      * Locations: 2

# to_dbl_scalar() provides informative error messages (#23)

    Code
      (expect_pkg_error_classes(to_dbl_scalar(given), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error:
      ! `given` must be a single <numeric>.
      x `given` has 2 values.

---

    Code
      (expect_pkg_error_classes(wrapped_to_dbl_scalar(given), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error in `wrapped_to_dbl_scalar()`:
      ! `val` must be a single <numeric>.
      x `val` has 2 values.

# to_dbl_scalar() respects allow_null (#23, #189)

    Code
      (expect_pkg_error_classes(to_dbl_scalar(given), "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_to_dbl_scalar(given), "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_to_dbl_scalar()`:
      ! `val` must not be <NULL>.

# to_dbl_scalar respects allow_zero_length (#23, #43, #45, #189)

    Code
      (expect_pkg_error_classes(to_dbl_scalar(given), "stbl", "bad_empty"))
    Output
      <error/stbl-error-bad_empty>
      Error:
      ! `given` must be a single <numeric (non-empty)>.
      x `given` has no values.

