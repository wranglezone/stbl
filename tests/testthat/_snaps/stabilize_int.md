# stabilize_int() checks min_value (#2, #6, #176)

    Code
      stabilize_int(given, min_value = 11)
    Condition
      Error:
      ! `given` must be >= 11.
      i Some values are too low.
      x Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10
      x Values: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10

---

    Code
      wrapped_stabilize_int(given, min_value = 11)
    Condition
      Error in `wrapped_stabilize_int()`:
      ! `val` must be >= 11.
      i Some values are too low.
      x Locations: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10
      x Values: 1, 2, 3, 4, 5, 6, 7, 8, 9, and 10

# stabilize_int() checks max_value (#5, #176)

    Code
      stabilize_int(given, max_value = 4)
    Condition
      Error:
      ! `given` must be <= 4.
      i Some values are too high.
      x Locations: 5, 6, 7, 8, 9, and 10
      x Values: 5, 6, 7, 8, 9, and 10

---

    Code
      wrapped_stabilize_int(given, max_value = 4)
    Condition
      Error in `wrapped_stabilize_int()`:
      ! `val` must be <= 4.
      i Some values are too high.
      x Locations: 5, 6, 7, 8, 9, and 10
      x Values: 5, 6, 7, 8, 9, and 10

# stabilize_int_scalar() errors on non-scalars (#12)

    Code
      stabilize_int_scalar(given)
    Condition
      Error:
      ! `given` must be a single <integer>.
      x `given` has 10 values.

---

    Code
      wrapped_stabilize_int_scalar(given)
    Condition
      Error in `wrapped_stabilize_int_scalar()`:
      ! `val` must be a single <integer>.
      x `val` has 10 values.

