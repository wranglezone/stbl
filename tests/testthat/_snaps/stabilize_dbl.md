# stabilize_dbl() checks min_value (#23, #176)

    Code
      stabilize_dbl(given, min_value = 11.1)
    Condition <stbl-error-outside_range>
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
      wrapped_stabilize_dbl(given, min_value = 11.1)
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_dbl()`:
      ! `val` must be >= 11.1.
      i Some values are too low.
      x Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10
      x Values: 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1, 9.1, and 10.1

# stabilize_dbl() checks max_value (#23, #176)

    Code
      stabilize_dbl(given, max_value = 4.1)
    Condition <stbl-error-outside_range>
      Error:
      ! `given` must be <= 4.1.
      i Some values are too high.
      x Locations: 5, 6, 7, 8, 9, and 10
      x Values: 5.1, 6.1, 7.1, 8.1, 9.1, and 10.1

---

    Code
      wrapped_stabilize_dbl(given, max_value = 4.1)
    Condition <stbl-error-outside_range>
      Error in `wrapped_stabilize_dbl()`:
      ! `val` must be <= 4.1.
      i Some values are too high.
      x Locations: 5, 6, 7, 8, 9, and 10
      x Values: 5.1, 6.1, 7.1, 8.1, 9.1, and 10.1

# stabilize_dbl_scalar() respects allow_null (#23, #189)

    Code
      stabilize_dbl_scalar(given)
    Condition <stbl-error-bad_null>
      Error:
      ! `given` must not be <NULL>.

---

    Code
      wrapped_stabilize_dbl_scalar(given)
    Condition <stbl-error-bad_null>
      Error in `wrapped_stabilize_dbl_scalar()`:
      ! `val` must not be <NULL>.

# stabilize_dbl_scalar() errors on non-scalars (#23)

    Code
      stabilize_dbl_scalar(given)
    Condition <stbl-error-non_scalar>
      Error:
      ! `given` must be a single <numeric>.
      x `given` has 10 values.

---

    Code
      wrapped_stabilize_dbl_scalar(given)
    Condition <stbl-error-non_scalar>
      Error in `wrapped_stabilize_dbl_scalar()`:
      ! `val` must be a single <numeric>.
      x `val` has 10 values.

# stabilize_dbl() checks allowed_values (#282)

    Code
      stabilize_dbl(c(1.1, 2.2, 3.3), allowed_values = c(1.1, 2.2))
    Condition <stbl-error-allowed_values>
      Error:
      ! `c(1.1, 2.2, 3.3)` must be one of the allowed values.
      i Allowed values: "1.1" and "2.2".
      x Unexpected location: 3
      x Unexpected value: "3.3".

---

    Code
      wrapped_stabilize_dbl(c(1.1, 2.2, 3.3), allowed_values = c(1.1, 2.2))
    Condition <stbl-error-allowed_values>
      Error in `wrapped_stabilize_dbl()`:
      ! `val` must be one of the allowed values.
      i Allowed values: "1.1" and "2.2".
      x Unexpected location: 3
      x Unexpected value: "3.3".

# stabilize_dbl_scalar() checks allowed_values (#282)

    Code
      stabilize_dbl_scalar(3.3, allowed_values = c(1.1, 2.2))
    Condition <stbl-error-allowed_values>
      Error:
      ! `3.3` must be one of the allowed values.
      i Allowed values: "1.1" and "2.2".
      x Unexpected location: 1
      x Unexpected value: "3.3".

