# stabilize_dbl() checks min_value (#23)

    Code
      stabilize_dbl(given, min_value = 11.1)
    Condition
      Error:
      ! Values of `given` must be >= 11.1.
      x Values are too low at locations 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10.

---

    Code
      wrapped_stabilize_dbl(given, min_value = 11.1)
    Condition
      Error in `wrapped_stabilize_dbl()`:
      ! Values of `val` must be >= 11.1.
      x Values are too low at locations 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10.

# stabilize_dbl() checks max_value (#23)

    Code
      stabilize_dbl(given, max_value = 4.1)
    Condition
      Error:
      ! Values of `given` must be <= 4.1.
      x Values are too high at locations 5, 6, 7, 8, 9, and 10.

---

    Code
      wrapped_stabilize_dbl(given, max_value = 4.1)
    Condition
      Error in `wrapped_stabilize_dbl()`:
      ! Values of `val` must be <= 4.1.
      x Values are too high at locations 5, 6, 7, 8, 9, and 10.

# stabilize_dbl_scalar() errors on non-scalars (#23)

    Code
      stabilize_dbl_scalar(given)
    Condition
      Error:
      ! `given` must be a single <numeric>.
      x `given` has 10 values.

---

    Code
      wrapped_stabilize_dbl_scalar(given)
    Condition
      Error in `wrapped_stabilize_dbl_scalar()`:
      ! `val` must be a single <numeric>.
      x `val` has 10 values.

