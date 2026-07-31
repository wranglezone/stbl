# stabilize_dbl() checks min_value (#23, #176)

    Code
      (expect_pkg_error_classes(stabilize_dbl(given, min_value = 11.1), "stbl",
      "outside_range"))
    Output
      <error/stbl-error-outside_range>
      Error:
      ! `given` must be >= 11.1.
      i Some values are too low.
      x Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10
      x Values: 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1, 9.1, and 10.1

---

    Code
      stabilize_dbl(given[[1]], min_value = 11.1)
    Condition
      Error:
      ! `given[[1]]` must be >= 11.1.
      x 1.1 is too low.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_dbl(given, min_value = 11.1),
      "stbl", "outside_range"))
    Output
      <error/stbl-error-outside_range>
      Error in `wrapped_stabilize_dbl()`:
      ! `val` must be >= 11.1.
      i Some values are too low.
      x Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10
      x Values: 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1, 9.1, and 10.1

# stabilize_dbl() checks max_value (#23, #176)

    Code
      (expect_pkg_error_classes(stabilize_dbl(given, max_value = 4.1), "stbl",
      "outside_range"))
    Output
      <error/stbl-error-outside_range>
      Error:
      ! `given` must be <= 4.1.
      i Some values are too high.
      x Locations: 5, 6, 7, 8, 9, and 10
      x Values: 5.1, 6.1, 7.1, 8.1, 9.1, and 10.1

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_dbl(given, max_value = 4.1), "stbl",
      "outside_range"))
    Output
      <error/stbl-error-outside_range>
      Error in `wrapped_stabilize_dbl()`:
      ! `val` must be <= 4.1.
      i Some values are too high.
      x Locations: 5, 6, 7, 8, 9, and 10
      x Values: 5.1, 6.1, 7.1, 8.1, 9.1, and 10.1

# stabilize_dbl_scalar() respects allow_null (#23, #189)

    Code
      (expect_pkg_error_classes(stabilize_dbl_scalar(given), "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_dbl_scalar(given), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_stabilize_dbl_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_dbl_scalar() errors on non-scalars (#23)

    Code
      (expect_pkg_error_classes(stabilize_dbl_scalar(given), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error:
      ! `given` must be a single <numeric>.
      x `given` has 10 values.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_dbl_scalar(given), "stbl",
      "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error in `wrapped_stabilize_dbl_scalar()`:
      ! `val` must be a single <numeric>.
      x `val` has 10 values.

