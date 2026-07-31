# stabilize_int() checks min_value (#2, #6, #176)

    Code
      (expect_pkg_error_classes(stabilize_int(given, min_value = 11), "stbl",
      "outside_range"))
    Output
      <error/stbl-error-outside_range>
      Error:
      ! `given` must be >= 11.
      i Some values are too low.
      x Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10
      x Values: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_int(given, min_value = 11), "stbl",
      "outside_range"))
    Output
      <error/stbl-error-outside_range>
      Error in `wrapped_stabilize_int()`:
      ! `val` must be >= 11.
      i Some values are too low.
      x Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10
      x Values: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10

# stabilize_int() checks max_value (#5, #176)

    Code
      (expect_pkg_error_classes(stabilize_int(given, max_value = 4), "stbl",
      "outside_range"))
    Output
      <error/stbl-error-outside_range>
      Error:
      ! `given` must be <= 4.
      i Some values are too high.
      x Locations: 5, 6, 7, 8, 9, and 10
      x Values: 5, 6, 7, 8, 9, and 10

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_int(given, max_value = 4), "stbl",
      "outside_range"))
    Output
      <error/stbl-error-outside_range>
      Error in `wrapped_stabilize_int()`:
      ! `val` must be <= 4.
      i Some values are too high.
      x Locations: 5, 6, 7, 8, 9, and 10
      x Values: 5, 6, 7, 8, 9, and 10

# stabilize_int_scalar() respects allow_null (#12, #189)

    Code
      (expect_pkg_error_classes(stabilize_int_scalar(given), "stbl", "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_int_scalar(given), "stbl",
      "bad_null"))
    Output
      <error/stbl-error-bad_null>
      Error in `wrapped_stabilize_int_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_int_scalar() errors on non-scalars (#12)

    Code
      (expect_pkg_error_classes(stabilize_int_scalar(given), "stbl", "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error:
      ! `given` must be a single <integer>.
      x `given` has 10 values.

---

    Code
      (expect_pkg_error_classes(wrapped_stabilize_int_scalar(given), "stbl",
      "non_scalar"))
    Output
      <error/stbl-error-non_scalar>
      Error in `wrapped_stabilize_int_scalar()`:
      ! `val` must be a single <integer>.
      x `val` has 10 values.

